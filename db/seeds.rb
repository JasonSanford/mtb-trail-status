tarheel_trails = YAML::load_file(Rails.root.join('db', 'seeds', 'trails_trailblazers.yml'))
tarheel_trails.each do |trail_obj|
  trail = Trail.new(trail_obj)
  trail.source = Trail::SOURCE_TARHEEL_TRAILBLAZERS
  trail.save!
end
puts "Created #{tarheel_trails.count} Tarheel trails."

usnwc_trails = YAML::load_file(Rails.root.join('db', 'seeds', 'trails_usnwc.yml'))
usnwc_trails.each do |trail_obj|
  trail = Trail.new(trail_obj)
  trail.source = Trail::SOURCE_USNWC
  trail.save!
end
puts "Created #{usnwc_trails.count} USNWC trails."
