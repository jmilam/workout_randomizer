class Category < ApplicationRecord
	has_many :workouts

	validates :name, presence: true

	enum style_tags: { 1 => { "background-color" => "bg-light", "border" => "border-light", "text-color" => "text-light" },
										 2 => { "background-color" => "bg-info", "border" => "border-info", "text-color" => "text-info"},
										 3 => { "background-color" => "bg-success", "border" => "border-success", "text-color" => "text-success"},
   									 4 => { "background-color" => "bg-warning", "border" => "border-warning", "text-color" => "text-warning"},
   									 5 => { "background-color" => "bg-primary", "border" => "border-primary", "text-color" => "text-primary"} }
end
