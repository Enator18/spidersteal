using Godot;
using System;

public partial class Spider : CharacterBody3D
{
	public const float Speed = 5.0f;
	public const float JumpVelocity = 4.5f;
	public const float LookSpeed = 0.005f;

	private SpringArm3D cameraArm;

	public override void _Ready()
	{
		Input.SetMouseMode(Input.MouseModeEnum.Captured);
		cameraArm = GetNode<SpringArm3D>("CameraArm");
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector3 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
		{
			velocity += GetGravity() * (float)delta;
		}

		if (Input.IsActionPressed("Quit"))
		{
			GetTree().Quit();
		}

		// Handle Jump.
		if (Input.IsActionJustPressed("Jump") && IsOnFloor())
		{
			velocity.Y = JumpVelocity;
		}

		// Get the input direction and handle the movement/deceleration.
		// As good practice, you should replace UI actions with custom gameplay actions.
		Vector2 inputDir = Input.GetVector("Left", "Right", "Forward", "Backward");
		Vector3 direction = (Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();
		if (direction != Vector3.Zero)
		{
			velocity.X = direction.X * Speed;
			velocity.Z = direction.Z * Speed;
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			velocity.Z = Mathf.MoveToward(Velocity.Z, 0, Speed);
		}

		Velocity = velocity;
		MoveAndSlide();
	}
	
	public override void _UnhandledInput(InputEvent @event)
	{
		if(@event is InputEventMouseMotion mouseEvent)
		{
			float xRotation = Rotation.Y - (mouseEvent.Relative.X * LookSpeed);
			float yRotation = cameraArm.Rotation.X + (mouseEvent.Relative.Y * LookSpeed);
			yRotation = Math.Max(Math.Min(yRotation, 10.0f * (float)Math.PI / 180.0f), -90.0f * (float)Math.PI / 180.0f);
			SetRotation(new Vector3(Rotation.X, xRotation, Rotation.Z));
			cameraArm.SetRotation(new Vector3(yRotation, cameraArm.Rotation.Y, cameraArm.Rotation.Z));
		}
	}
}
