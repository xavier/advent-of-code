(let [boss {:hp 58 :damage 8}
      player {:hp 50 :mana 500 :mana-spent 0 :armor 0 :shield 0 :poison 0 :recharge 0}
      spells ["magic missile" "drain" "shield" "poison" "recharge"]]

  (defn apply-effects [player boss]
    [(cond-> player
       (= 0 (player :shield)) (assoc-in [:armor] 0)
       (< 0 (player :shield)) (assoc-in [:armor] 7)
       (< 0 (player :recharge)) (update-in [:mana] + 101)
       (< 0 (player :shield)) (update-in [:shield] dec)
       (< 0 (player :poison)) (update-in [:poison] dec)
       (< 0 (player :recharge)) (update-in [:recharge] dec))
     (cond-> boss (< 0 (player :poison)) (update-in [:hp] - 3))])

  (defn attack [player boss]
    (let [[p b] (apply-effects player boss)]
      [(update-in p [:hp] - (max 1 (- (b :damage) (p :armor))))
       b]))

  (defn cast-spell [player boss spell hard]
    (let [player-mod (if hard (update-in player [:hp] dec) player)
          [p b] (apply-effects player-mod boss)]
      (if (and hard (>= 0 (player-mod :hp)))
        [player-mod boss]
        (cond
          (= spell "magic missile")
            [(-> p (update-in [:mana] - 53) (update-in [:mana-spent] + 53))
             (-> b (update-in [:hp] - 4))]
          (= spell "drain")
            [(-> p (update-in [:mana] - 73) (update-in [:mana-spent] + 73) (update-in [:hp] + 2))
             (-> b (update-in [:hp] - 2))]
          (= spell "shield")
            [(-> p (update-in [:mana] - 113) (update-in [:mana-spent] + 113) (assoc-in [:shield] 6))
             b]
          (= spell "poison")
            [(-> p (update-in [:mana] - 173) (update-in [:mana-spent] + 173) (assoc-in [:poison] 6))
             b]
          (= spell "recharge")
            [(-> p (update-in [:mana] - 229) (update-in [:mana-spent] + 229) (assoc-in [:recharge] 5))
             b]))))

  (defn choose-spell [player]
    (let [choices '(0)
          mana (player :mana)]
      (nth spells (rand-nth (cond-> choices
                              (> mana 73) (conj 1)
                              (and (= 0 (player :shield)) (> mana 113)) (conj 2)
                              (and (= 0 (player :poison)) (> mana 173)) (conj 3)
                              (and (= 0 (player :recharge)) (> mana 229)) (conj 4))))))

  (defn attack-til-dead [player boss hard]
    (loop [[p b] (cast-spell player boss (choose-spell player) hard)
           turn "player"]
      (if (and (>= 0 (b :hp)) (< 0 (p :mana)) (< 0 (p :hp)))
        (p :mana-spent)
        (if (or (>= 0 (p :hp)) (>= 0 (p :mana)))
          nil
          (if (= turn "player")
            (recur (attack p b) "boss")
            (recur (cast-spell p b (choose-spell player) hard) "player"))))))

  (println "Part 1:" (apply min (filter some? (take 5000000 (repeatedly #(attack-til-dead player boss false))))))
  (println "Part 2:" (apply min (filter some? (take 5000000 (repeatedly #(attack-til-dead player boss true)))))))
