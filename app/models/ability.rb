class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.teacher? && user.userable.admin?
      can :manage, :all
    elsif user.teacher?
      can :read, :all
    elsif user.student?
      can :read, :all
      can :read, Category
      can :read, Course
      can :read, CourseRequirement
      can :manage, StudentCourse do |sc|
        sc.student_id == user.id
      end
    else
      can :create, User
      can :create, Student
      can :create, Teacher
    end
  end
end
