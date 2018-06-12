require 'pry'

class Student
  attr_accessor :id, :name, :grade
  
  # create a new Student object given a row from the database
  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    
    student = self.new.tap do |student|
      student.id = id
      student.name = name
      student.grade = grade
    end
  end

  # retrieve all the rows from the "Students" database, 
  # each as an instance of the Student class
  def self.all
    sql = <<-SQL
      SELECT *
      FROM students;
    SQL
    
    students = DB[:conn].execute(sql)
    students.map { |row| self.new_from_db(row) }
  end
  
  # find the student in the database given a name 
  # and return as a Student instance
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE name = ?;
    SQL
    
    database_entry = DB[:conn].execute(sql, name).first
    student = self.new_from_db(database_entry)
    student
    
    # Alternative using the map helper
    # DB[:conn].execute(sql, name).map do |row|
    #   self.new_from_db(row)
    # end.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, @name, @grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students;"
    DB[:conn].execute(sql)
  end
  
  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * 
      FROM students 
      WHERE grade = 9;
    SQL
    
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12;
    SQL
    
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end
  
  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?;
    SQL
    
    DB[:conn].execute(sql, x).map do |row|
      self.new_from_db(row)
    end
  end
  
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1;
    SQL
    
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?;
    SQL
    
    DB[:conn].execute(sql, x).map do |row|
      self.new_from_db(row)
    end
  end
end
