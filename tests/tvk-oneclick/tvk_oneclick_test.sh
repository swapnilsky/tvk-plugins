#!/usr/bin/env bash

set -o pipefail

ONECLICK_TESTS_SUCCESS=true

# shellcheck source=/dev/null
source tools/tvk-oneclick/tvk-oneclick.sh
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

testcreate_target() {
  current_dir=$PWD
  cd tools/tvk-oneclick || return
  create_target
  rc=$?
  # shellcheck disable=SC2181
  if [ $rc != "0" ]; then
    # shellcheck disable=SC2082
    echo "Failed - test create_target, Expected 0 got $rc"
  fi
  cd "$current_dir" || return
  return $rc
}

testsample_test(){
  current_dir=$PWD
  cd tools/tvk-oneclick || return
  sample_test
  rc=$?
  # shellcheck disable=SC2181
  if [ $rc != "0" ]; then
    # shellcheck disable=SC2082
    echo "Failed - test sample_test, Expected 0 got $rc"
  fi
  cd "$current_dir" || return
  return $rc
}

testsample_test_helm(){
  current_dir=$PWD
  cd tools/tvk-oneclick || return
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
  cd "$current_dir" || return
  return $rc
}

testsample_test_namespace(){
  current_dir=$PWD
  cd tools/tvk-oneclick || return
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
  cd "$current_dir" || return
  return $rc
}

testsample_test_operator(){
  current_dir=$PWD
  cd tools/tvk-oneclick || return
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
  cd "$current_dir" || return
  return $rc
}

testinstallTVK
retCode=$?
if [[ retCode -ne 0 ]]; then
  ONECLICK_TESTS_SUCCESS=false
fi

testconfigure_ui
retCode=$?
if [[ retCode -ne 0 ]]; then
  ONECLICK_TESTS_SUCCESS=false
fi

testcreate_target
retCode=$?
if [[ retCode -ne 0 ]]; then
  ONECLICK_TESTS_SUCCESS=false
fi

testsample_test
retCode=$?
if [[ retCode -ne 0 ]]; then
  ONECLICK_TESTS_SUCCESS=false
fi

testsample_test_helm
retCode=$?
if [[ retCode -ne 0 ]]; then
  ONECLICK_TESTS_SUCCESS=false
fi

testsample_test_namespace
retCode=$?
if [[ retCode -ne 0 ]]; then
  ONECLICK_TESTS_SUCCESS=false
fi

testsample_test_operator
retCode=$?
if [[ retCode -ne 0 ]]; then
  ONECLICK_TESTS_SUCCESS=false
fi

# Check status of TVK-oneclick test-cases
if [ $ONECLICK_TESTS_SUCCESS == "true" ]; then
  echo -e "All TVK-oneclick tests Passed!"
else
  echo -e "Some TVK-oneclick Checks Failed!"
  exit 1
fi

