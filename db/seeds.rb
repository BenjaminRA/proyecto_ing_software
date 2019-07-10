# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

AbilitiesType.create(:type_name => "Competencias Técnicas")
AbilitiesType.create(:type_name => "Competencias Blandas")

State.create(:state => "Activo")
State.create(:state => "Inactivo")

user = User.create(:name => "admin", :last_name => "", :email => "admin@contac.cl", :password_digest => "root", :rut => 0)
Admin.create(:user_id => user.id)