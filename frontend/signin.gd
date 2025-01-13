extends Control

signal authenticated
var main

func _ready() -> void:
	$SignIn.show()
	$NoAccount.show()
	$SignInButton.show()
	$CreateAccount.hide()
	$HasAccount.hide()
	$CreateAccountButton.hide()
	main = $".."

func _on_no_account_button_pressed() -> void:
	if not $"../Loading".visible:
		$SignIn.hide()
		$NoAccount.hide()
		$SignInButton.hide()
		$CreateAccount.show()
		$HasAccount.show()
		$CreateAccountButton.show()
		$Username.text = ""
		$Password.text = ""

func _on_has_account_button_pressed() -> void:
	if not $"../Loading".visible:
		$SignIn.show()
		$NoAccount.show()
		$SignInButton.show()
		$CreateAccount.hide()
		$HasAccount.hide()
		$CreateAccountButton.hide()
		$Username.text = ""
		$Password.text = ""
		$Username.editable = true
		$Password.editable = true

func _on_sign_in() -> void:
	if not $"../Loading".visible:
		$Username.editable = false
		$Password.editable = false
		$"../Loading".show()
		$"../Loading/Circle".play()
		main.get_all_users.rpc(Global.id)
		var all_users = await main.responded
		if $Username.text in all_users:
			main.get_user_info.rpc($Username.text,"password",Global.id)
			var pwd = await main.responded
			pwd = pwd.split(";")
			if ($Password.text+pwd[0]).sha256_text() == pwd[1]:
				Global.user = $Username.text
				authenticated.emit()
			else:
				$AlertDialog.dialog_text = "Password Incorrect"
				$AlertDialog.visible = true
				$"../Loading".hide()
				$"../Loading/Circle".stop()
				$Username.editable = true
				$Password.editable = true
		else:
			$AlertDialog.dialog_text = "Username Not Found"
			$AlertDialog.visible = true
			$"../Loading".hide()
			$"../Loading/Circle".stop()
			$Username.editable = true
			$Password.editable = true

func _on_create_account() -> void:
	if not $"../Loading".visible:
		$Username.editable = false
		$Password.editable = false
		$"../Loading".show()
		$"../Loading/Circle".play()
		if $Username.text != "":
			main.get_all_users.rpc(Global.id)
			var all_users = await main.responded
			if not $Username.text in all_users:
				if $Password.text != "":
					var salt = get_salt()
					var hashed = ($Password.text+salt).sha256_text()
					var entry = salt+';'+hashed
					main.new_user.rpc($Username.text, entry)
					Global.user = $Username.text
					authenticated.emit()
				else:
					$AlertDialog.dialog_text = "Please Choose a Password"
					$AlertDialog.visible = true
					$"../Loading".hide()
					$"../Loading/Circle".stop()
					$Username.editable = true
					$Password.editable = true
			else:
				$AlertDialog.dialog_text = "Username Already Taken"
				$AlertDialog.visible = true
				$"../Loading".hide()
				$"../Loading/Circle".stop()
				$Username.editable = true
				$Password.editable = true
		else:
			$AlertDialog.dialog_text = "Please Choose a Username"
			$AlertDialog.visible = true
			$"../Loading".hide()
			$"../Loading/Circle".stop()
			$Username.editable = true
			$Password.editable = true

func _username_validate_text(new_text: String) -> void:
	var regex = RegEx.new()
	regex.compile("[:, ;\\(\\)\\0]")
	var result = regex.search(new_text)
	var cached_caret_pos = $Username.caret_column
	if result:
		$Username.text = regex.sub($Username.text, "", true)
		$Username.caret_column = cached_caret_pos - 1

func _password_validate_text(new_text: String) -> void:
	var regex = RegEx.new()
	regex.compile("[:, ;\\(\\)\\0]")
	var result = regex.search(new_text)
	var cached_caret_pos = $Password.caret_column
	if result:
		$Password.text = regex.sub($Password.text, "", true)
		$Password.caret_column = cached_caret_pos - 1

func get_salt() -> String:
	return str(Crypto.new().generate_random_bytes(8).to_int64_array()[0]).sha256_text()
