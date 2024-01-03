#!/bin/bash

generate() {
  name=$1
  expected=$2
  value=$3
  status=$4
  desc=$5
  printf '{"name": "%s", "expected": "%s", "value": "%s", "status": "%s", "desc": "%s"}' "$name" "$expected" "$value" "$status" "$desc"
}

checkPasswordMinLength() {
  expected="10"
  value=$(cat /etc/login.defs | grep PASS_MIN_LEN | grep -v ^# | awk '{print $2}')
  if [ -z "$value" ]; then
    status="fail"
    desc="无法获取密码最小长度值"
  elif ! expr "$value" + 1 >/dev/null 2>&1; then
    status="fail"
    desc="密码最小长度值无效"
  elif [ "$(expr "$value" \>= "$expected")" -eq 1 ]; then
    status="pass"
  else
    status="fail"
    desc="当前密码最小长度为 $value，建议设置最小长度大于等于 $expected"
  fi
  echo $(generate "pass_min_len" "$expected" "$value" "$status" "$desc")
}

checkPermitRootLogin() {
  expected="no"
  value=$(grep -E "^PermitRootLogin" /etc/ssh/sshd_config | cut -d " " -f 2)
  if [ "$value" == "$expected" ]; then
    status="pass"
  else
    status="fail"
    desc="不建议允许 root 用户进行 SSH 登录"
  fi
  echo $(generate "permit_root_login" "$expected" "$value" "$status" "$desc")
}

checkSELinux() {
  expected="disabled"
  value=$(grep -E "^SELINUX=" /etc/selinux/config | cut -d "=" -f 2)
  if [ "$value" != "$expected" ]; then
    status="pass"
  else
    status="fail"
    desc="SELinux 已禁用，可能存在安全风险"
  fi
  echo $(generate "selinux_not_disabled" "$expected" "$value" "$status" "$desc")
}

checkDefaultSSHPort() {
  expected="22"
  value=$(grep -E "^Port" /etc/ssh/sshd_config | cut -d " " -f 2)
  if [ "$value" != "$expected" ]; then
    status="pass"
  else
    status="fail"
    desc="当前为默认 SSH 端口，端口号 $value，建议修改"
  fi
  echo $(generate "default_ssh_port" "$expected" "$value" "$status" "$desc")
}

checkPassMaxDays() {
  expected="90"
  value=$(cat /etc/login.defs | grep PASS_MAX_DAYS | grep -v ^# | awk '{print $2}')
  if [ $value -le $expected -a $value -gt 0 ]; then
    status="pass"
  else
    status="fail"
    desc="当前密码生存周期为 $value 天，建议设置不大于 $expected 天"
  fi
  echo $(generate "pass_max_days" "$expected" "$value" "$status" "$desc")
}

checkPassMinDays() {
  expected="6"
  value=$(cat /etc/login.defs | grep PASS_MIN_DAYS | grep -v ^# | awk '{print $2}')
  if [ $value -ge $expected ]; then
    status="pass"
  else
    status="fail"
    desc="当前密码最小更改间隔为 $value 天，建议设置大于等于 $expected 天"
  fi
  echo $(generate "pass_min_days" "$expected" "$value" "$status" "$desc")
}

checkPassWarnAge() {
  expected="30"
  value=$(cat /etc/login.defs | grep PASS_WARN_AGE | grep -v ^# | awk '{print $2}')
  if [ $value -ge $expected ]; then
    status="pass"
  else
    status="fail"
    desc="口令过期警告时间天数为 $value，建议设置大于等于 $expected 并小于口令生存周期"
  fi
  echo $(generate "pass_warn_age" "$expected" "$value" "$status" "$desc")
}

checkTelnet() {
  expected="0"
  value=$(rpm -qa | grep telnet | wc -l)
  if [ $value == $expected ]; then
    status="pass"
  else
    status="fail"
    desc="检测到安装了 telnet 服务，建议禁用"
  fi
  echo $(generate "check_telnet" "$expected" "$value" "$status" "$desc")
}

checkICMP() {
  expected="0"
  value=$(cat /proc/sys/net/ipv4/icmp_echo_ignore_all)
  if [ $value != $expected ]; then
    status="pass"
  else
    status="fail"
    desc="服务器未禁 ping，建议禁用"
  fi
  echo $(generate "check_icmp" "$expected" "$value" "$status" "$desc")
}

main() {
  result='[
    '"$(checkPasswordMinLength)"',
    '"$(checkPermitRootLogin)"',
    '"$(checkSELinux)"',
    '"$(checkDefaultSSHPort)"',
    '"$(checkPassMaxDays)"',
    '"$(checkPassMinDays)"',
    '"$(checkPassWarnAge)"',
    '"$(checkTelnet)"',
    '"$(checkICMP)"'
  ]'
  echo $result
}

main
