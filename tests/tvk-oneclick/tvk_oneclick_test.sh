#!/usr/bin/env bash

set -o pipefail

PREFLIGHT_TESTS_SUCCESS=true

# shellcheck source=/dev/null
source tools/tvk-oneclick/tvk-oneclick 
source tests/tvk-oneclick/input_file
path_export=$PWD/tools/tvk-oneclick
export PATH=$PATH:$path_export

export input_config=tests/tvk-oneclick/input_file


testinstallTVK() {
  install_tvk
  rc=$?
  # shellcheck disable=SC2181
  if [ $rc != "0" ]; then
    # shellcheck disable=SC2082
    echo "Failed - test install_tvk, Expected 0 got $rc"
  fi
  return $rc
}
#testinstallTVK


testconfigure_ui() {
  rc=0
  configure_ui
  rc=$?
  # shellcheck disable=SC2181
  if [ $rc != "0" ]; then
    # shellcheck disable=SC2082
    echo "Failed - test configure_ui, Expected 0 got $rc"
  fi
  return $rc
}
#testconfigure_ui

testcreate_target() {
  current_dir=$PWD
  cd tools/tvk-oneclick
  create_target
  rc=$?
  # shellcheck disable=SC2181
  if [ $rc != "0" ]; then
    # shellcheck disable=SC2082
    echo "Failed - test create_target, Expected 0 got $rc"
  fi
  cd $current_dir
  return $rc
}
testcreate_target

testsample_test(){
  current_dir=$PWD
  cd tools/tvk-oneclick
  sample_test
  rc=$?
  # shellcheck disable=SC2181
  if [ $rc != "0" ]; then
    # shellcheck disable=SC2082
    echo "Failed - test sample_test, Expected 0 got $rc"
  fi
  cd $current_dir
  return $rc
}
testsample_test

testsample_test_helm(){
  current_dir=$PWD
  cd tools/tvk-oneclick
  sed -i "s/\(backup_way *= *\).*/\1\'Helm_based\'/" $input_config
  sed -i "s/\(bk_plan_name *= *\).*/\1\'trilio-test-helm\'/" $input_config
  sed -i "s/\(backup_name *= *\).*/\1\'trilio-test-helm\'/" $input_config
  sed -i "s/\(restore_name *= *\).*/\1\'trilio-test-helm\'/" $input_config
  sample_test
  rc=$?
  # shellcheck disable=SC2181
  if [ $rc != "0" ]; then
    # shellcheck disable=SC2082
    echo "Failed - test sample_test, Expected 0 got $rc"
  fi
  cd $current_dir
  return $rc
}
testsample_test_helm

testsample_test_namespace(){
  current_dir=$PWD
  cd tools/tvk-oneclick
  sed -i "s/\(backup_way *= *\).*/\1\'Namespace_based\'/" $input_config
  sed -i "s/\(bk_plan_name *= *\).*/\1\'trilio-test-namespace\'/" $input_config
  sed -i "s/\(backup_name *= *\).*/\1\'trilio-test-namespace\'/" $input_config
  sed -i "s/\(restore_name *= *\).*/\1\'trilio-test-namespace\'/" $input_config
  sample_test
  rc=$?
  # shellcheck disable=SC2181
  if [ $rc != "0" ]; then
    # shellcheck disable=SC2082
    echo "Failed - test sample_test, Expected 0 got $rc"
  fi
  cd $current_dir
  return $rc
}
testsample_test_namespace

testsample_test_operator(){
  current_dir=$PWD
  cd tools/tvk-oneclick
  sed -i "s/\(backup_way *= *\).*/\1\'Operator_based\'/" $input_config
  sed -i "s/\(bk_plan_name *= *\).*/\1\'trilio-test-operator\'/" $input_config
  sed -i "s/\(backup_name *= *\).*/\1\'trilio-test-operator\'/" $input_config
  sed -i "s/\(restore_name *= *\).*/\1\'trilio-test-operator\'/" $input_config
  sample_test
  rc=$?
  # shellcheck disable=SC2181
  if [ $rc != "0" ]; then
    # shellcheck disable=SC2082
    echo "Failed - test sample_test, Expected 0 got $rc"
  fi
  cd $current_dir
  return $rc
}
testsample_test_operator
