require 'fastercsv'
namespace :app do
namespace :exposures do

	desc "Destroy all the existing exposures."
	task :destroy_all => :environment do
		puts "Destroying all exposures"
		Exposure.destroy_all
	end

	desc "Destroy and re-import the exposures from csv files."
	task :import => :destroy_all do
		puts "Importing all questions."
		Dir['DB_Mid-level Groupings_*_08-09-2011_NF.csv'].each do |csv|
			puts "Processing file:#{csv}"
			category = csv.match(/DB_Mid-level Groupings_(.*)_08-09-2011_NF.csv/)[1]
			(f=FasterCSV.open(csv, 'rb',{ :headers => true })).each do |line|
				study_name = line['Study'].strip
				puts "Processing exposure line #{f.lineno}:#{study_name}"

				unless( %w( CCLS AUS-ALL ).include?(study_name) )
					puts "Skipping this study for demo purposes."
					next
				end
	
				study = Study.find_by_name(study_name)
				raise "Can't find study:#{study_name}" unless study
	
				study.exposures.create!({
					:category            => category,
					:relation_to_child   => line["Relation to Child"],
					:windows             => line['Window of Exposure'].to_s.split(',').collect(&:strip),
					:types               => line['Type of Exposure'].to_s.split(',').collect(&:strip),
					:assessments         => line['Exposure Assessment'].to_s.split(',').collect(&:strip),
					:locations_of_use    => line['Location of Use'].to_s.split(',').collect(&:strip),
					:forms_of_contact    => line['Form of Contact'].to_s.split(',').collect(&:strip)
				})

#break if f.lineno > 1
			end
		end	#	Dir['DB_Mid-level Groupings_*_08-09-2011_NF.csv'].each do |csv|
		puts "Loaded #{pluralize(Exposure.count,'exposure')}."
		puts "Reindexing"
		Exposure.solr_reindex
		puts "Done"
	end	#	task :import do
end	#	namespace :exposures do
end	#	namespace :app do
