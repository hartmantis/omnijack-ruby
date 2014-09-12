# Encoding: UTF-8

Feature: Metadata
  In order to find out what package to download
  As an Omnitruck API consumer
  I want to access package metadata

  Scenario Outline: All default <Project>
    Given a Ubuntu 12.04 node
    And no special arguments
    When I create a <Project> project
    Then the metadata has a url attribute
    And the metadata has a filename attribute
    And the metadata has an md5 attribute
    And the metadata has a sha256 attribute
    And the metadata doesn't have a yolo attribute
    Examples:
      | Project       |
      | AngryChef     |
      | Chef          |
      | ChefDk        |
      | ChefContainer |
      | ChefServer    |

  Scenario Outline: <Project> with nightlies enabled
    Given a Ubuntu 12.04 node
    And nightlies enabled
    When I create a <Project> project
    Then the metadata has a url attribute
    And the metadata has a filename attribute
    And the metadata has an md5 attribute
    And the metadata has a sha256 attribute
    And the metadata has a yolo attribute
    Examples:
      | Project       |
    # | AngryChef     | There are no nightly builds for AngryChef(?)
      | Chef          |
      | ChefDk        |
      | ChefContainer |
      | ChefServer    |

  # We can't quite be guaranteed of a prerelease version of anything existing
  # Scenario Outline: <Project> with prerelease enabled
