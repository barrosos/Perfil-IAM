#!/bin/bash

gen_pw() {
  head -c 9 /dev/urandom | uuencode -m - | head -2 | tail -1 |  tr '1IlO0' '$/%&#'
}

while read user  # generacion de perfiles de usuario
do
  password=$(gen_pw)
  aws iam create-user --user-name "$user"
  aws iam attach-user-policy --user-name="$user" --policy-arn=arn:aws:iam::435501576190:policy/S3-Access-sftp-release-binaries
  aws iam create-login-profile --user-name="$user" --password="$password" --password-reset-required
  echo "created $user with password $password"
done < my_users_file.txt