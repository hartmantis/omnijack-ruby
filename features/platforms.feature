# Encoding: UTF-8

Feature: Package platforms
  In order to see what all packages are available
  As an Omnitruck API consumer
  I want to access package list data

  Scenario Outline: All default <Project>
    Given no special arguments
    When I create a <Project> project
    Then the platforms maps the following items:
      | Nickname | FullName         |
      | el       | Enterprise Linux |
      | debian   | Debian           |
      | freebsd  | FreeBSD          |
    Examples:
    # Some endpoints aren't served by Chef's public Omnitruck API
      | Project       |
      | AngryChef     |
      | Chef          |
      | ChefDk        |
      | ChefContainer |
      | ChefServer    |
