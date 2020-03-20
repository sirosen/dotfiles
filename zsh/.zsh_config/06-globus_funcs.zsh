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
  # special tuning param for ops-adminpy to turn off MFA
  # export OPS_ADMIN_EXTERNAL_MFA=1
  local mfafile="$HOME/.globus_mfa_users"
  AWS_PROFILE="users" \
    ADMIN_AWS_MFA_SN="arn:aws:iam::942379385228:mfa/sirosen" \
    mfa-login "$mfafile" --mmin 540 || return $?
  mfa-to-profile mfa-activated "$mfafile"
}

globus-mfa-users-bad () {
  # special tuning param for ops-adminpy to turn off MFA
  # export OPS_ADMIN_EXTERNAL_MFA=1
  local mfafile="$HOME/.globus_mfa_users"
  AWS_PROFILE="users" \
    ADMIN_AWS_MFA_SN="arn:aws:iam::280831789029:role/globus_admin" \
    mfa-login "$mfafile" --mmin 540 || return $?
  mfa-to-profile mfa-activated "$mfafile"
}


_switch_aws_account() {
  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SECURITY_TOKEN
  set-tmux-title "$1-AWS"
  export AWS_PROFILE="$1" # EC2SSH_PUBLIC_IP=0
  unset EC2SSH_PUBLIC_IP
  export EC2SSH_AUTODETECT=1

  case "$AWS_PROFILE" in
    dev)
      unset AWS_PROFILE
      # export EC2SSH_PUBLIC_IP=1
      ;;
    ops)
      export GLOBUS_OPS_KEYPAIR=stephen_key
      ;;
    *)
      ;;
  esac
}
setprofile-nexus () { _switch_aws_account nexus; }
setprofile-ops () { _switch_aws_account ops; }
setprofile-transfer () { _switch_aws_account transfer; }
setprofile-dns () { _switch_aws_account dns; }
setprofile-search () { _switch_aws_account search; }
setprofile-webapps () { _switch_aws_account webapps; }
setprofile-dev () { _switch_aws_account dev; }

export SWITCH_AWS_ACCOUNT_HOOK=_switch_aws_account

set-sdk-env () {
  export GLOBUS_SDK_ENVIRONMENT="$1"
}


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
