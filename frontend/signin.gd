extends Control

signal authenticated
var main
var secure = 0

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
		$Capital.show()
		$Number.show()
		$Special.show()
		$"8Chars".show()
		_password_validate_text("")

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
		$Capital.hide()
		$Number.hide()
		$Special.hide()
		$"8Chars".hide()

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
					if secure == 4:
						var salt = get_salt()
						var hashed = ($Password.text+salt).sha256_text()
						var entry = salt+';'+hashed
						main.new_user.rpc($Username.text, entry)
						Global.user = $Username.text
						authenticated.emit()
					else:
						$AlertDialog.dialog_text = "Please Choose a Secure Password"
						$AlertDialog.visible = true
						$"../Loading".hide()
						$"../Loading/Circle".stop()
						$Username.editable = true
						$Password.editable = true
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
	regex.compile("[:,;\\s\\(\\)\\0]")
	var result = regex.search(new_text)
	var cached_caret_pos = $Username.caret_column
	if result:
		$Username.text = regex.sub($Username.text, "", true)
		$Username.caret_column = cached_caret_pos - 1

func _password_validate_text(new_text: String) -> void:
	secure = 0
	var regex = RegEx.new()
	regex.compile("[:, ;\\(\\)\\0]")
	var result = regex.search(new_text)
	var cached_caret_pos = $Password.caret_column
	if result:
		$Password.text = regex.sub($Password.text, "", true)
		$Password.caret_column = cached_caret_pos - 1
	regex.compile("[A-Z]")
	if regex.search($Password.text):
		$Capital.set("theme_override_colors/font_color", Color(0,1,0))
		$Capital.text = "[✓] Capital Letter"
		secure += 1
	else:
		$Capital.set("theme_override_colors/font_color", Color(1,0,0))
		$Capital.text = "[X] Capital Letter"
	regex.compile("[0-9]")
	if regex.search($Password.text):
		$Number.set("theme_override_colors/font_color", Color(0,1,0))
		$Number.text = "[✓] Number"
		secure += 1
	else:
		$Number.set("theme_override_colors/font_color", Color(1,0,0))
		$Number.text = "[X] Number"
	regex.compile("[^A-Za-z0-9]")
	if regex.search($Password.text):
		$Special.set("theme_override_colors/font_color", Color(0,1,0))
		$Special.text = "[✓] Special Character"
		secure += 1
	else:
		$Special.set("theme_override_colors/font_color", Color(1,0,0))
		$Special.text = "[X] Special Character"
	if len($Password.text) >= 8:
		$"8Chars".set("theme_override_colors/font_color", Color(0,1,0))
		$"8Chars".text = "[✓] 8+ Characters"
		secure += 1
	else:
		$"8Chars".set("theme_override_colors/font_color", Color(1,0,0))
		$"8Chars".text = "[X] 8+ Characters"

func get_salt() -> String:
	return str(Crypto.new().generate_random_bytes(8).to_int64_array()[0]).sha256_text()
