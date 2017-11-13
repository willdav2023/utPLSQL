create or replace package ut_runner authid current_user is

  /*
  utPLSQL - Version X.X.X.X
  Copyright 2016 - 2017 utPLSQL Project

  Licensed under the Apache License, Version 2.0 (the "License"):
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  */

  function version return varchar2;

  /**
  * Check if version is compatible with another version (by default the current framework version)
  * Version is compatible if:
  *   a_current.major = a_requested.major
  *   a_requested.minor < a_current.minor or a_requested.minor = a_current.minor and a_requested.bugfix <= a_current.bugfix
  *
  * @param     a_requested requested utPLSQL version string
  * @param     a_current   current   utPLSQL version string, if null is passed, defaults to current framework version
  * @return    1/0         1-true, 0-false
  * @exception 20214       if passed version string is not matching version pattern
  */
  function version_compatibility_check( a_requested varchar2, a_current varchar2 := null ) return integer;

  /**
  * Execute specified suites/tests by paths
  * @param a_paths                  list of schemes, packages, procedures or suite-paths to execute
  * @param a_reporters              list of reporter objects (formats) to use for reporting
  * @param a_color_console          true/false - should the console format reporters use ANSI color tags
  * @param a_coverage_schemes       list of database schemes to include in coverage
  * @param a_source_file_mappings   list of project source files mapped to DB objects that coverage should be reported on
  * @param a_test_file_mappings     list of project test files mapped to DB objects that test results should be reported on
  * @param a_include_objects        list of database objects (in format 'owner.name') that coverage should be reported on
  * @param a_exclude_objects        list of database objects (in format 'owner.name') that coverage should be skipped for
  * @param a_fail_on_errors         true/false - should an exception be thrown when tests are completed with failures/errors
  *
  * @example
  * Parameter `a_paths` accepts values of the following formats:
  *   schema - executes all suites in the schema
  *   schema:suite1[.suite2] - executes all items of suite1 (suite2) in the schema.
  *                          suite1.suite2 is a suitepath variable
  *   schema:suite1[.suite2][.test1] - executes test1 in suite suite1.suite2
  *   schema.suite1 - executes the suite package suite1 in the schema "schema"
  *                 all the parent suites in the hiearcy setups/teardown procedures as also executed
  *                 all chile items are executed
  *   schema.suite1.test2 - executes test2 procedure of suite1 suite with execution of all parent setup/teardown procedures
  */
  procedure run(
    a_paths ut_varchar2_list, a_reporters ut_reporters, a_color_console boolean := false,
    a_coverage_schemes ut_varchar2_list := null, a_source_file_mappings ut_file_mappings := null, a_test_file_mappings ut_file_mappings := null,
    a_include_objects ut_varchar2_list := null, a_exclude_objects ut_varchar2_list := null, a_fail_on_errors boolean default false
  );

  /**
   * Rebuilds annotation cache for a specified schema and object type.
   *  The procedure is called internally by `get_annotated_objects` function.
   *  It can be used to speedup initial execution of utPLSQL on a given schema
   *   if it is executed before any call is made to `ut.run` or `ut_runner.run` procedure.
   *
   * @param a_object_owner owner of objects to get annotations for
   * @param a_object_type type of objects to get annotations for
   */
  procedure rebuild_annotation_cache(a_object_owner varchar2, a_object_type varchar2);

  /**
   * Removes cached information about annotations for objects of specified type and specified owner
   *
   * @param a_object_owner owner of objects to purge annotations for
   * @param a_object_type type of objects to purge annotations for
   */
  procedure purge_cache(a_object_owner varchar2, a_object_type varchar2);

end ut_runner;
/
