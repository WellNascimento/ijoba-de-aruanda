extends CharacterBody2D

# Carregado antes de entrar na cena
var data: CharacterData

# Stats dinâmicos
var vida_atual: float
var is_dashing := false
var dash_timer := 0.0
var dash_cooldown_timer := 0.0
var facing_direction := 1

# Habilidades
var habilidade_1_cooldown := 0.0
var habilidade_2_cooldown := 0.0
var habilidade_3_cooldown := 0.0

func inicializar(character_data: CharacterData) -> void:
	data = character_data
	vida_atual = data.vida_maxima

func _physics_process(delta: float) -> void:
	if data == null:
		return
	_apply_gravity(delta)
	_handle_dash(delta)
	_handle_movement()
	_handle_jump()
	_handle_habilidades(delta)
	move_and_slide()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 980.0 * delta

func _handle_movement() -> void:
	if is_dashing:
		return
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * data.velocidade
		facing_direction = int(direction)
		$Sprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, data.velocidade)

func _handle_jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = data.forca_pulo

func _handle_dash(delta: float) -> void:
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	if Input.is_action_just_pressed("ui_focus_next") \
		and dash_cooldown_timer <= 0 \
		and not is_dashing:
		is_dashing = true
		dash_timer = 0.2
		dash_cooldown_timer = data.cooldown_dash
	if is_dashing:
		dash_timer -= delta
		velocity.x = facing_direction * data.velocidade_dash
		if dash_timer <= 0:
			is_dashing = false

func _handle_habilidades(delta: float) -> void:
	if habilidade_1_cooldown > 0: habilidade_1_cooldown -= delta
	if habilidade_2_cooldown > 0: habilidade_2_cooldown -= delta
	if habilidade_3_cooldown > 0: habilidade_3_cooldown -= delta

	# Habilidade 1 — Z
	if Input.is_action_just_pressed("habilidade_1") and habilidade_1_cooldown <= 0:
		_usar_habilidade_1()

	# Habilidade 2 — X
	if Input.is_action_just_pressed("habilidade_2") and habilidade_2_cooldown <= 0:
		_usar_habilidade_2()

func _usar_habilidade_1() -> void:
	match data.nome:
		"ze_pilintra":
			# Cachaça Sagrada — cura + speed buff
			vida_atual = min(vida_atual + 30.0, data.vida_maxima)
			habilidade_1_cooldown = 8.0
			print("Zé usou Cachaça Sagrada! Vida: ", vida_atual)
		"maria_navalha":
			# Dança da Navalha — spin attack (lógica de área virá depois)
			habilidade_1_cooldown = 6.0
			print("Maria usou Dança da Navalha!")

func _usar_habilidade_2() -> void:
	match data.nome:
		"ze_pilintra":
			# Fumaça do Charuto
			habilidade_2_cooldown = 10.0
			print("Zé usou Fumaça do Charuto!")
		"maria_navalha":
			# Rosa de Pemba
			habilidade_2_cooldown = 7.0
			print("Maria usou Rosa de Pemba!")

func receber_dano(dano: float) -> void:
	vida_atual -= dano
	print("Vida restante: ", vida_atual)
	if vida_atual <= 0:
		_morrer()

func _morrer() -> void:
	print(data.nome, " morreu!")
	# Lógica de morte virá depois
