# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/)

To skip CI build, git commit with [ci skip] in commit message

## [0.2.3] - 2021-03-10
### Added
- Support `:queue` option

## [0.2.2] - 2021-01-21
### Fixed
- `.with_terminator` didn't set job status to 'failed' when cathing :fail

## [0.2.1] - 2021-01-20
### Fixed
- Use 'pluralize' for the migration class name

## [0.2.0] - 2021-01-19
### Changed
- Refactor code with `ActiveSupport::Concern`

## [0.1.0] - 2021-01-19
### Added
- `RailsAsyncJob` module
