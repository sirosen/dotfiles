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
setprofile-automate () { _switch_aws_account automate; }
setprofile-webapps () { _switch_aws_account webapps; }
setprofile-dev () { _switch_aws_account dev; }

export SWITCH_AWS_ACCOUNT_HOOK=_switch_aws_account

set-sdk-env() {
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

# generic completer for multiple uses
_globus_env_complete() {
    _arguments "*: :((sandbox integration test staging preview production))"
}

# service-specific

get-flows-rds-cxn () {
    aws secretsmanager get-secret-value \
        --secret-id "flows/$1" \
        --query "SecretString" \
        --output text | jq '.rds.users.admin.db_url' -r
}
compdef _globus_env_complete get-flows-rds-cxn

globus-flows-healthcheck () {
  local base_url="https://flows.automate.globus.org"
  case "$1" in
    production)
      ;;
    *)
      base_url="https://${1}.flows.automate.globus.org"
      ;;
  esac
  curl -s "${base_url}/health/check"
}
compdef _globus_env_complete globus-flows-healthcheck

nexus-auth () {
    curl -v -H "Content-Type: application/json" --data \
        '{"username":"'"$1"'","password":"'"$2"'"}' \
        https://nexus.api.globusonline.org/authenticate
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

globus-username-to-urn () {
  local username="$1"
  echo "urn:globus:auth:identity:$(globus get-identities "$username" --jmespath 'identities[].id' -Funix)"
}
