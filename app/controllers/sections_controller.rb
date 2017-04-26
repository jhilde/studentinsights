class SectionsController < ApplicationController
  include StudentsQueryHelper

  # Authentication by default inherited from ApplicationController.

  before_action :authorize_and_assign_section

  def show
    cookies[:columns_selected] ||= initial_columns.to_json

    @rows = eager_students().map {|student| fat_student_hash(student) }

    # Risk level chart
    #@risk_levels = @section.student_risk_levels.group(:level).count
    #@risk_levels['null'] = if @risk_levels.has_key? nil then @risk_levels[nil] else 0 end

    # Dropdown for homeroom navigation
    @sections_by_name = current_educator.allowed_sections_by_name

    # For links to STAR pages
    @school_id = @section.students.active.map(&:school_id).uniq.first
    @star_homeroom_anchor = "equal:homeroom_name:#{@section.name}"
  end

  private

  def initial_columns
    return ['name', 'risk', 'sped', 'mcas_math', 'mcas_ela', 'interventions'] if @section.show_mcas?
    return ['name', 'risk', 'sped', 'interventions']
  end

  def eager_students(*additional_includes)
    @section.students.active.includes([
      :interventions,
      :student_risk_level,
      :homeroom,
      :student_school_years
    ] + additional_includes)
  end

  # Serializes a Student into a hash with other fields joined in (that are used to perform
  # filtering and slicing in the UI).
  # This may be slow if you're doing it for many students without eager includes.
  def fat_student_hash(student)
    HashWithIndifferentAccess.new(student_hash_for_slicing(student).merge({
      interventions: student.interventions,
      sped_data: student.sped_data,
      student_risk_level: student.student_risk_level.decorate.as_json_with_explanation
    }))
  end

  def authorize_and_assign_section
    @requested_section = Section.friendly.find(params[:id])

    if current_educator.allowed_sections.include? @requested_section
      @section = @requested_section
    else
      redirect_to homepage_path_for_role(current_educator)
    end
  rescue ActiveRecord::RecordNotFound     # Params don't match an actual homeroom
    redirect_to homepage_path_for_role(current_educator)
  end
end
