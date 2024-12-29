extends Control

signal authenticated

func _ready() -> void:
	$SignIn.show()
	$NoAccount.show()
	$SignInButton.show()
	$CreateAccount.hide()
	$HasAccount.hide()
	$CreateAccountButton.hide()

func _on_no_account_button_pressed() -> void:
	$SignIn.hide()
	$NoAccount.hide()
	$SignInButton.hide()
	$CreateAccount.show()
	$HasAccount.show()
	$CreateAccountButton.show()
	$Username.text = ""
	$Password.text = ""

func _on_has_account_button_pressed() -> void:
	$SignIn.show()
	$NoAccount.show()
	$SignInButton.show()
	$CreateAccount.hide()
	$HasAccount.hide()
	$CreateAccountButton.hide()
	$Username.text = ""
	$Password.text = ""

func _on_sign_in() -> void:
	if $Username.text in await Global.get_all_users():
		if $Password.text == await Global.get_user_info($Username.text,"password"):
			Global.user = $Username.text
			authenticated.emit()
		else:
			$AlertDialog.dialog_text = "Password Incorrect"
			$AlertDialog.visible = true
	else:
		$AlertDialog.dialog_text = "Username Not Found"
		$AlertDialog.visible = true

func _on_create_account() -> void:
	if $Username.text != "":
		if not $Username.text in await Global.get_all_users():
			if $Password.text != "":
				await Global.new_user($Username.text, $Password.text)
				Global.user = $Username.text
				authenticated.emit()
			else:
				$AlertDialog.dialog_text = "Please Choose a Password"
				$AlertDialog.visible = true
		else:
			$AlertDialog.dialog_text = "Username Already Taken"
			$AlertDialog.visible = true
	else:
		$AlertDialog.dialog_text = "Please Choose a Username"
		$AlertDialog.visible = true
