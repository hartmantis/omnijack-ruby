# Encoding: UTF-8

Feature: Package lists
  In order to see what all packages are available
  As an Omnitruck API consumer
  I want to access package list data

  Scenario Outline: All default <Project>
    Given no special arguments
    When I create a <Project> project
    Then the list has a section for Ubuntu 12.04 x86_64
    Examples:
    # Some endpoints aren't served by Chef's public Omnitruck API
      | Project       |
    # | AngryChef     |
      | Chef          |
    # | ChefDk        |
    # | ChefContainer |
      | ChefServer    |
