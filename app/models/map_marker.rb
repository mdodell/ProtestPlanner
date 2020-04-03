class MapMarker < ApplicationRecord
  enum marker_type: %i[start end police counter_protestors road_blocked rally_point]
end
