## Constants and hard coded facts about the dataset used in
## processing.

class Data
  # The admissible skew parameters.
  SKEWS =
    [
     0,
     100,
     200,
     500,
     1000,
     2000,
     5000,
     10000,
     20000,
     50000
    ]

  APPS_TO_NAMES = {
    gasbuddy: "Gasbuddy",
    restaurant_finder: "Restaurant Finder",
    hospitals: "Hospitals Near Me",
    tdbank: "TD Bank",
    walmart: "Walmart",
    webmd: "WebMD"
  }
end
