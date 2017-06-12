class Applist
  APPLIST = %w[gasbuddy restaurant_finder hospitals tdbank walmart webmd]
end

Applist::APPLIST.each { |app|
  require "./#{app}"
}
