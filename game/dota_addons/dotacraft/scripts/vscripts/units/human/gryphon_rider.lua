function StormHammer( event )
	local caster = event.caster
	local target = event.target
	local targets = event.target_entities
	local ability = event.ability

	local next_target = targets[1]
	if next_target == target then
		next_target = targets[2]
	end

	if next_target then
		local projTable = {
			EffectName = "particles/units/heroes/hero_zuus/zuus_base_attack.vpcf",
			Ability = ability,
			Target = next_target,
			Source = target,
			bDodgeable = true,
			bProvidesVision = false,
			vSpawnOrigin = target:GetAbsOrigin(),
			iMoveSpeed = 900,
			iVisionRadius = 0,
			iVisionTeamNumber = caster:GetTeamNumber(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
		}
		ProjectileManager:CreateTrackingProjectile( projTable )
		print("Storm Hammer Launched to "..next_target:GetUnitName().." number ".. next_target:GetEntityIndex())
	end
end

function StormHammerDamage( event )
	local caster = event.caster
	local target = event.target
	local damage = caster:GetAverageTrueAttackDamage()
	local ability = event.ability
	local AbilityDamageType = ability:GetAbilityDamageType()

	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = AbilityDamageType })
	print("Storm Hammer dealt "..damage.." to "..target:GetUnitName().." number ".. target:GetEntityIndex())
end

function Mount( event )
	local caster = event.caster
	local ability = event.ability

	local attach = caster:ScriptLookupAttachment("attach_hitloc")
	local origin = caster:GetAttachmentOrigin(attach)
	local fv = caster:GetForwardVector()

	local rider = CreateUnitByName("human_gryphon_mounted_dummy", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber()) 
	ability:ApplyDataDrivenModifier(caster, rider, "modifier_disable_rider", {})

	rider:SetAbsOrigin(Vector(origin.x, origin.y, origin.z-30))
	rider:SetAngles(0,90,0)
	rider:SetParent(caster, "attach_hitloc")

	caster.rider = rider
end

function FakeAttack( event )
	local caster = event.caster

	caster.rider:StartGesture(ACT_DOTA_ATTACK)
end