class Category < ApplicationRecord
	has_many :workouts

	validates :name, presence: true

	enum style_tags: { 1 => { "background-color" => "bg-light", "border" => "border-light", "text-color" => "text-light", "thead-color" => "bg-light" },
										 2 => { "background-color" => "bg-info", "border" => "border-info", "text-color" => "text-info", "thead-color" => "bg-info"},
										 3 => { "background-color" => "bg-success", "border" => "border-success", "text-color" => "text-success", "thead-color" => "bg-success"},
   									 4 => { "background-color" => "bg-warning", "border" => "border-warning", "text-color" => "text-warning", "thead-color" => "bg-warning"},
   									 5 => { "background-color" => "bg-primary", "border" => "border-primary", "text-color" => "text-primary", "thead-color" => "bg-primary"} }
end
