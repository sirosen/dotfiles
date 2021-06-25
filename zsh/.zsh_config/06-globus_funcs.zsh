#
# Multi-Factor Auth + Account Switching
#

_set_role_in_env () {
  # for setting the role in environment variables, which works well with
  # non-python tools and boto2
  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SECURITY_TOKEN
  local rolefile="$HOME/.globus_role_tmp"
  AWS_PROFILE="mfa-activated" assume-role "$1" "$rolefile" || return $?
  source "$rolefile"
  rm "$rolefile"
}

profile2env-nexus () {
    _set_role_in_env "arn:aws:iam::303064072663:role/globus_admin"
}


globus-mfa-users () {
  local mfafile="$HOME/.globus_mfa_users"
  AWS_PROFILE="users" \
    ADMIN_AWS_MFA_SN="arn:aws:iam::942379385228:mfa/sirosen" \
    mfa-login "$mfafile" --mmin 540 || return $?
  mfa-to-profile mfa-activated "$mfafile"
}

globus-mfa-users-bad () {
  local mfafile="$HOME/.globus_mfa_users"
  AWS_PROFILE="users" \
    ADMIN_AWS_MFA_SN="arn:aws:iam::280831789029:role/globus_admin" \
    mfa-login "$mfafile" --mmin 540 || return $?
  mfa-to-profile mfa-activated "$mfafile"
}


_switch_aws_account() {
  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SECURITY_TOKEN
  export AWS_PROFILE="$1" # EC2SSH_PUBLIC_IP=0
  unset EC2SSH_PUBLIC_IP
  export EC2SSH_AUTODETECT=1

  case "$AWS_PROFILE" in
    dev)
      export AWS_PROFILE=dev
      # export EC2SSH_PUBLIC_IP=1
      ;;
    ops)
      export GLOBUS_OPS_KEYPAIR=stephen_key
      ;;
    *)
      ;;
  esac
}
setprofile-funcx () { _switch_aws_account funcx; }
setprofile-nexus () { _switch_aws_account nexus; }
setprofile-ops () { _switch_aws_account ops; }
setprofile-transfer () { _switch_aws_account transfer; }
setprofile-dns () { _switch_aws_account dns; }
setprofile-search () { _switch_aws_account search; }
setprofile-webapps () { _switch_aws_account webapps; }
setprofile-dev () { _switch_aws_account dev; }

export SWITCH_AWS_ACCOUNT_HOOK=_switch_aws_account

set-sdk-env () {
  case "$1" in
    nil|none)
      unset GLOBUS_SDK_ENVIRONMENT
      ;;
    *)
      export GLOBUS_SDK_ENVIRONMENT="$1"
      ;;
  esac
}
_sdk_env_zsh_complete() {
    _arguments "*: :((nil sandbox integration test staging preview production))"
}
compdef _sdk_env_zsh_complete set-sdk-env


# chef

update-cookbook-version () {
    cd ~/dev/ops/chef-repo/environments
    cb="$1"
    ver="$2"
    sed -i "s/\"$cb\": \"= [[:digit:]]\+.[[:digit:]]\+.[[:digit:]]\+\"/\"$cb\": \"= $ver\"/g" ./*
}

chef-find-sshable-nodes () {
    for h in $(knife node list); do
        EC2SSH_DISABLE_KNOWN_HOSTS=1 ec2ssh -o "ConnectTimeout=1" "$h" '[ -d /var/chef/ ] && hostname' 2>/dev/null
    done
}

# service-specific

nexus-auth () {
    curl -v -H "Content-Type: application/json" --data \
        '{"username":"'"$1"'","password":"'"$2"'"}' \
        https://nexus.api.globusonline.org/authenticate
}

globus-username-to-urn () {
  local username="$1"
  echo "urn:globus:auth:identity:$(globus get-identities "$username" --jmespath 'identities[].id' -Funix)"
}


gcp-download-url () {
  local showall
  showall=0
  while [ $# -gt 0 ]; do
    case "$1" in
      "-h"|"--help")
        echo "gcp-download-urls [-h|--help] [-a|--all]"
        return 0
        ;;
      "-a"|"--all")
        showall=1
        ;;
      *)
        return 2
    esac
    shift 1
  done

  DOWNLOAD_BASE='https://downloads.globus.org/globus-connect-personal/v3'
  if [ $showall -eq 0 ]; then
    echo "${DOWNLOAD_BASE}/linux/stable/globusconnectpersonal-latest.tgz"
  else
    echo "LINUX:\n  ${DOWNLOAD_BASE}/linux/stable/globusconnectpersonal-latest.tgz"
    echo "WIN:\n  ${DOWNLOAD_BASE}/windows/stable/globusconnectpersonal-latest.exe"
    echo "MAC:\n  ${DOWNLOAD_BASE}/mac/stable/globusconnectpersonal-latest.dmg"
  fi
}


# globus-cli wrappers
globus-my-shared-eps () {
  globus endpoint search \
      --filter-scope my-endpoints -Fjson \
      --limit 100 \
      --jq 'DATA[?host_endpoint_id!=null].id' \
      -Funix | tr '\t' '\n'
}
