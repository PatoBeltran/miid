class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    elsif user.teacher?
      can :read, :all
      can [:read, :link_course, :search_courses, :course_description], Course
      can [:show_tree, :show], Student
    elsif user.student?
      can :show, Student do |s|
        s.id == user.userable_id
      end
      can :read, Category
      can [:read, :link_course, :search_courses, :course_description], Course
      can :read, CourseRequirement
      can :manage, StudentCourse do |sc|
        sc.student_id == user.userable_id
      end
      can [:show_tree, :show], Student
    else
      can :create, User
      can :create, Student
      can :create, Teacher
    end
  end
end
