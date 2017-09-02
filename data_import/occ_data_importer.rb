# encoding: utf-8

require 'rubygems'
require 'active_record'
require 'spreadsheet'


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: '../GlassCup.sqlite3')

class Occ < ActiveRecord::Base

end


# main
class DoctorImporter

  def import
    $data_file = Spreadsheet.open './occ_data.xls'
    $sheet = $data_file.worksheet 0
    $sheet.each_with_index do |row, index|
      next if index == 0
      break if row[0].nil?

      occ = Occ.new
      occ.name = row[0]
      occ.code = row[1]
      occ.local_name = row[2]
      occ.lng = row[6]
      occ.lat = row[7]
      occ.address = row[10]
      occ.terminal_type = row[19]
      occ.capacity = row[21]
      occ.installation_method = row[24]
      occ.data_collector = row[36]
      occ.data_collect_date = row[37]
      occ.ori_project_code = row[39]
      occ.ori_project_name = row[40]
      occ.save

    end
  end

  # def has_undefine_data?
    # result = false
    # undefine_hospitals= []
    # undefine_hospital_rooms = []
    # $sheet.each_with_index do |row, index|
      # next if index == 0
      # hospital_room = row[3]
      # hospital = row[4]

      # #检查城市名称是否与数据库匹配
      # undefine_hospitals << "#{index}:#{hospital}" if has_undefine_hospital? hospital
      # undefine_hospital_rooms << "#{index}:#{hospital_room}" if has_undefine_hospital_room? hospital_room
    # end
    # puts "[#{undefine_hospitals.join(',')}] 不在数据库中" unless undefine_hospitals.empty?
    # puts "[#{undefine_hospital_rooms.join(',')}] 不在数据库中" unless undifine_hospital_rooms.empty?
    # result = true unless undefine_hospitals.empty? or undifine_hospital_rooms.empty?
    # result
  # end



  # def has_undefine_hospital? hospital_name
    # hospital_name unless Hospital.find_by_name(hospital_name)
  # end

  # def has_undefine_hospital_room? hospital_room_name
    # hospital_room_name unless HospitalRoom.find_by_name(hospital_room_name)
  # end



  # def import
  #   # return if has_undefine_data?
  #   #
  #   (0..7).each do |i|
  #     sheet = $data_file.worksheet i
  #
  #     sheet.each_with_index do |row, index|
  #       next if index == 0
  #       break if row[0].nil?
  #       print "#{index}, "
  #
  #       hospital = Hospital.find_by_name(row[4])
  #       hospital_room = HospitalRoom.find_by_name(row[3])
  #
  #       if hospital.nil? or hospital_room.nil?
  #         next
  #       else
  #         next unless Doctor.where(name: row[0]).where(hospital_id: hospital.id).empty?
  #         doctor = Doctor.new
  #         doctor.name = row[1]
  #         doctor.hospital = hospital
  #         doctor.hospital_room = hospital_room
  #         doctor.position = row[2] if row[2]
  #         doctor.desc = row[5] if row[5]
  #         doctor.save
  #       end
  #     end
  #   end
  # end
end


DoctorImporter.new.import
