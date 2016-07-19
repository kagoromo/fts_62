class Admins::SubjectsController < ApplicationController
  load_and_authorize_resource

  def show
    @questions = @subject.questions.page(params[:page]).
      per Settings.admin.subject_question.per_page
  end

  def index
    @subjects = @subjects.page(params[:page]).
      per Settings.admin.subject.per_page
  end

  def create
    if @subject.save
      flash[:success] = t "subject.add_success"
      redirect_to admins_subjects_path
    else
      flash[:danger] = t "subject.add_fail"
      render :new
    end
  end

  def edit
    @chatwork_room_name = @subject.get_chatwork_room_name current_admin
  end

  def update
    if @subject.update_attributes subject_params
      flash[:success] = t "subject.edit_success"
      redirect_to admins_subjects_path
    else
      flash[:danger] = t "subject.edit_failed"
      render :edit
    end
  end

  def destroy
    @subject.destroy ?
      (flash[:success] = t "subject.delete_success") :
      (flash[:danger] = t "subject.delete_fail")
    redirect_to admins_subjects_path
  end

  private
  def subject_params
    params.require(:subject).permit :content, :number_of_questions, :duration,
      :chatwork_room_id
  end
end
