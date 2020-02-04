# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
gym = Gym.create!(name: "Boomslang Fitness", phone_number: "336-707-7939")
gym.categories.create!(name: "Lean Muscle Gain", goal_id: User.goals.keys[1])
lose_weight = gym.categories.create!(name: "Lose Weight", goal_id: User.goals.keys[0])

chest_exercises = ["Flat Chest Press", "Incline Chest Press", "Decline Chest Press", "Chest Fly", "Overhead Pull", "Pushup"]
back_exercises = ["Sitting Row", "Bent Over Row", "Pulldown", "Pull up", "Back Fly", "Chin Up", "Inverted Row", "Lat Raise", "Shrugs", "Deadlift", "Sled Pull"]
bicep_exercises = ["Curl & Extend", "Preacher Curl", "Alternating Curl", "Inclined Curl", "21's", "Hammer Curl", "Outside Curl", "Standard Curl"]
shoulder_exercises = ["Military Press", "Lateral Raise", "Front Raise", "Upright Rows", "Face Pull", "Around The World", "Swings", "Rotator Rotation", "Shoulder Drag"]
tricep_exercises = ["Push Down", "Kickback", "Dips", "Close Grip Press", "Overhead Press", "Skull Crusher"]
leg_exercises = ["Standard Squat", "Leg Press", "Calf Raise", "Lunge", "Sled Push", "Leg Curl", "Leg Extension", "Calf Press", "Reverese Lunge", "Side Lunge", "Goblit Squat", "Sumo Squat", "Step Up"]
full_body = ["Turkish Get Up", "Half Turkish Get Up", "Squat Press"]
abs = ["Spiderman & Reverse Through Crunch", "Mountain Climbers", "Side Plank", "Plank"]
mb = ["Lunge/Twist"]
chest_exercises.concat(back_exercises, bicep_exercises, shoulder_exercises, tricep_exercises, leg_exercises, full_body, abs, mb).each do |exercise|
  CommonExercise.create!(name: exercise)
end

equipment = ["Cable", "Barbell", "Dumbbell", "Kettlebell", "Band", "Rope", "Sled", "Pull Up Bar", "Dip Bar",
             "Box", "Curl Bar", "Hex Bar", "SandBag", "Body"]

equipment.each do |equip|
  CommonEquipment.create!(name: equip)
end

tasks = [{ name: "Large Group Classes", duration: 45, select_client: false },
         { name: "Personl Training", duration: 30, select_client: true },
         { name: "Small Group", duration: 45, select_client: false }]

tasks.each do |task_hash|
  tym.tasks.create(name: task_hash[:name], duration: task_hash[:duration], select_client: task_hash[:select_client])
end
