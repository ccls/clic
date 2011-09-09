require 'fastercsv'

def arrayify(value)
	#	to_s in case is nil
	value.to_s.split(',').collect(&:strip)
end

namespace :app do
namespace :exposures do

	desc "Destroy all the existing exposures."
	task :destroy_all => :environment do
		puts "Destroying all exposures"
		Exposure.destroy_all
	end

	desc "Destroy and re-import the exposures from csv files."
	task :import => :destroy_all do
		puts "Importing all exposures."
		Dir['DB_Mid-level Groupings_*_08-09-2011_NF*.csv'].each do |csv|
			puts "Processing file:#{csv}"
			category = csv.match(/DB_Mid-level Groupings_(.*)_08-09-2011_NF/)[1]
			(f=FasterCSV.open(csv, 'rb',{ :headers => true })).each do |line|
				study_name = line['Study'].strip
				puts "Processing exposure line #{f.lineno}:#{study_name}"

#				unless( %w( CCLS AUS-ALL ).include?(study_name) )
				unless( ['CCLS','AUS-ALL','COG','GCCR','France - ESCALE','Quebec'].include?(study_name) )
					puts "Skipping this study for demo purposes."
					next
				end
	
				study = Study.find_by_name(study_name)
				raise "Can't find study:#{study_name}" unless study
	
				study.exposures.create!({
					:category            => category,
					:relation_to_child   => line["Relation to Child"].to_s.strip,
					:windows             => arrayify(line['Window of Exposure']),
					:types               => arrayify(line['Type of Exposure']),
					:assessments         => arrayify(line['Exposure Assessment']),
					:locations_of_use    => arrayify(line['Location of Use']),
					:forms_of_contact    => arrayify(line['Form of Contact'])
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
