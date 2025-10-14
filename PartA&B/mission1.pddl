(define (problem lunar-mission-1)
    (:domain lunar)

    (:objects
    rover1 - rover
    landerA - lander
    wp1 wp2 wp3 wp4 wp5 - location
    sample1 - sample
    )

    (:init
    ;; Lander sits at WP1 (so sample can be stored there right away)
    (lander-at landerA wp1)
    (lander-slot-free landerA)

    ;; Rover starts undeployed (must deploy at the lander first)
    (not (deployed rover1))

    ;; Physical sample on the ground at WP1
    (sample-at sample1 wp1)

    ;; Directed edges exactly as in the figure (ONLY these directions):
    (connected wp1 wp2)
    (connected wp2 wp3)
    (connected wp1 wp4)
    (connected wp4 wp3)
    (connected wp5 wp1)
    (connected wp3 wp5)
    )

    (:goal (and
    (image-saved wp5)                 ; image taken at WP5 and transmitted
    (scan-saved  wp3)                 ; scan taken at WP3 and transmitted
    (lander-has-sample landerA sample1) ; sample from WP1 stored in the lander
  ))
)