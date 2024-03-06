extends Node3D

@onready var head = $RootNode/Skeleton3D/Head
@onready var right_hand = $RootNode/Skeleton3D/RightHand
@onready var left_hand = $RootNode/Skeleton3D/LeftHand
@onready var spine = $RootNode/Skeleton3D/Spine
@onready var skeleton = $RootNode/Skeleton3D
@onready var animation_tree := $AnimationTree


