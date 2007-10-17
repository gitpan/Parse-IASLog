use inc::Module::Install;
name 'Parse-IASLog';
author 'Chris Williams';
version_from 'lib/Parse/IASLog.pm';
abstract_from 'lib/Parse/IASLog.pm';
license 'perl';
build_requires 'Test::More' => 0.47;
requires 'Exporter' => 0;
WriteAll;
