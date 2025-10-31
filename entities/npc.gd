extends CharacterBody2D

func damage(v: int):
    print("DAMAGE ", v)
    queue_free()
