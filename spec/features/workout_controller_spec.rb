require 'rails_helper'

RSpec.describe 'Workout', js: true do
  let(:user) { create(:user, current_workout: workout.id) }
	let(:workout) { create(:workout) }
  let!(:workout_group) { create(:workout_group, workout: workout)}
  let!(:exercise_circuit) { create(:exercise_circuit)}
  let!(:exercise) { create(:exercise, workout_group: workout_group,
  																		exercise_circuit_id: exercise_circuit.id)}

  before do
    sign_in user
    visit profile_index_path
  	click_on 'Suggested Workout'
		sleep(5)
  end

	context 'Complete Workout' do
		it 'brings up workout' do
			expect(all('.rep_input').count).to eq(exercise.set_count)
			expect(page).to have_content("#{exercise.name}")
			expect(page).to have_content("#{exercise.rep_range}")
		end

		it 'saves exercise' do
			all('.rep_input').each do |input|
				input.set 25
			end
			click_button "Next Exercise (0 of #{workout.exercises.count} complete)"

			expect(page).to have_content("There are no Workouts for you!")
		end
	end
end