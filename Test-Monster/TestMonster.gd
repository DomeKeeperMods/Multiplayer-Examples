extends Monster


# Since we use the walking path system we need these
const moveType: String = "walk_medium"
const moveSpeed: float = 120.0
var path: Path2D
var progress := 0.0
var meleeTarget: Path2D
var variant: String
var pathIndex: int 

var damageTween: Tween

# Determine if we are attacking or walking
var lastDelta: float
var walking: bool = true

func init():
	position = path.curve.sample_baked(progress) + path.global_position
	var d = position.x - (path.curve.sample_baked(progress + 5).x + path.global_position.x)
	lastDelta = -d
	setFlip(d > 0.0)
	resumeAnimation()
	updateHitboxState()
	
func subProcess(delta):
	if walking:
		progress += delta * moveSpeed * sprite.speed_scale
		var cp = meleeTarget.curve.get_closest_point($HitPosition.global_position)
		if sign(lastDelta) != sign(cp.x - $HitPosition.global_position.x):
			# We're now attacking
			walking = false
			animation("drill")
		else:
			position = path.curve.sample_baked(progress) + path.global_position
			
func leave(delta:float):
	if progress > 0.0:
		progress = max(0, progress - delta * moveSpeed * sprite.speed_scale)
		position = path.curve.sample_baked(progress) + path.global_position
		
func onGameLost():
	if currentHealth > 0:
		animation("walk")
		leaving = true
		$Sprite2D.speed_scale = 0.9 + randf() * 0.5
		setFlip(not $Sprite2D.flip_h)
		
func animateDeath():
	animation("liedown")
	await sprite.animation_finished
	super.removeFreeBlocker()
	
func resumeAnimation() -> void:
	if walking:
		animation("walk")
	else:
		animation("drill")
	
func attack():
	var dome = Level.domesByTeamId[teamId]
	dome.requestMeleeDamage(Data.of("walker.damage") * damageModifier, $HitPosition.global_position, self)
	InputSystem.shake(40, 0.3, 8, $HitPosition.global_position)

static func get_spawn_data(variant: String, teamId:String, pathIndex: int = -1, progress: float = -1.0, damageSource: int = -1) -> PackedByteArray:
	var stream := PackedByteStream.new()

	# Encode our variant (side)
	stream.encode_bool(Utils.get_side_bool_from_string(variant))
	
	# Get our path
	if pathIndex == -1:
		pathIndex = Level.worldsByTeamId[teamId].getPathIndex(moveType, variant)
	stream.encode_u32(pathIndex)
	
	stream.encode_float(progress)
	stream.encode_u8(damageSource)
	return stream.data
	
func set_spawn_data(buffer: PackedByteArray):
	var stream := PackedByteStream.from_bytes(buffer)

	# Decode our variant
	variant = Utils.get_side_string_from_bool(stream.decode_bool())
	
	# Decode our path
	meleeTarget = Level.domesByTeamId[teamId].getMeleeTarget(variant)
	pathIndex = stream.decode_u32()
	path = Level.worldsByTeamId[teamId].getPaths(moveType, variant)[pathIndex]
	Level.worldsByTeamId[teamId].assignPathOccupation(moveType, path, self)
	
	var incomingProgress := stream.decode_float()
	if incomingProgress != -1:
		progress = incomingProgress
	var incomingDamageSource := stream.decode_u8()
	if incomingDamageSource != -1:
		damageSource = "bloater" if incomingDamageSource == Monster.Type.BLOATER else ""

func _on_sprite_2d_frame_changed() -> void:
	if sprite.animation == "drill" and sprite.frame == 3:
		attack()
