class Exercise {
  final String title;
  final String image;
  final String description;
  final String technique;
  final String advantages;
  final String history;

  const Exercise({
    required this.title,
    required this.image,
    required this.description,
    required this.technique,
    required this.advantages,
    required this.history,
  });
}

final Map<String, List<Exercise>> exercise = {
  // ------------------- HAPPY -------------------
  "happy": [
    Exercise(
      title: "Setu Bandhasana (Bridge Pose)",
      image: "assets/exercises/happy/setu_bandhasana.png",
      description:
      "Setu Bandhasana, commonly known as Bridge Pose, is a reclining backbend yoga posture that opens the chest and strengthens the spine.",
      technique:
      "1. Lie flat on your back with knees bent and feet hip-width apart.\n"
          "2. Place your arms beside your body, palms facing down.\n"
          "3. Press feet into the floor and lift hips towards the ceiling.\n"
          "4. Clasp hands under your back and press shoulders into the mat.\n"
          "5. Hold for 30–60 seconds while breathing deeply.",
      advantages:
      "• Strengthens the back, glutes, and hamstrings.\n"
          "• Opens the chest and lungs, improving respiration.\n"
          "• Reduces anxiety, stress, and fatigue.\n"
          "• Stimulates thyroid and abdominal organs.",
      history:
      "The name derives from Sanskrit: 'Setu' (bridge), 'Bandha' (lock), and 'Asana' (pose). It has been practiced in traditional Hatha Yoga to promote balance and rejuvenation.",
    ),
    Exercise(
      title: "Surya Namaskar (Sun Salutation)",
      image: "assets/exercises/happy/suryanamaskar.png",
      description:
      "Surya Namaskar is a dynamic sequence of 12 yoga postures performed in a flow, honoring the Sun and boosting vitality.",
      technique:
      "1. Begin in Prayer Pose (Pranamasana).\n"
          "2. Move into Raised Arms Pose (Hasta Uttanasana).\n"
          "3. Fold forward into Standing Forward Bend (Uttanasana).\n"
          "4. Step back into Ashwa Sanchalanasana (Equestrian Pose).\n"
          "5. Transition into Plank Pose.\n"
          "6. Lower down in Ashtanga Namaskar.\n"
          "7. Lift into Cobra Pose (Bhujangasana).\n"
          "8. Move into Downward Dog (Adho Mukha Svanasana).\n"
          "9. Step forward into Equestrian Pose.\n"
          "10. Return to Forward Bend.\n"
          "11. Rise into Raised Arms Pose.\n"
          "12. Return to Prayer Pose.",
      advantages:
      "• Improves blood circulation and flexibility.\n"
          "• Enhances cardiovascular health.\n"
          "• Boosts mood and reduces stress.\n"
          "• Stimulates metabolism and aids digestion.",
      history:
      "Surya Namaskar dates back thousands of years as a ritual to worship the Sun God. It is integral to many yoga traditions as a holistic practice.",
    ),
    Exercise(
      title: "Ustrasana (Camel Pose)",
      image: "assets/exercises/happy/ustrasana.png",
      description:
      "Ustrasana, or Camel Pose, is a deep backbend that stretches the entire front body while strengthening the back and shoulders.",
      technique:
      "1. Kneel on the mat with knees hip-width apart.\n"
          "2. Place hands on the lower back or heels for support.\n"
          "3. Inhale deeply and arch the spine backward.\n"
          "4. Drop the head gently while pushing hips forward.\n"
          "5. Hold the pose for 20–40 seconds, breathing evenly.",
      advantages:
      "• Improves spinal flexibility.\n"
          "• Opens chest, lungs, and shoulders.\n"
          "• Stimulates digestive and endocrine systems.\n"
          "• Reduces anxiety and fatigue.",
      history:
      "From Sanskrit 'Ustra' (camel), this pose is rooted in classical Hatha Yoga and symbolizes resilience and openness of heart.",
    ),
    Exercise(
      title: "Virabhadrasana (Warrior Pose)",
      image: "assets/exercises/happy/virabhadrasana.png",
      description:
      "Virabhadrasana, or Warrior Pose, is a powerful standing posture that builds stamina and focus.",
      technique:
      "1. Stand with feet wide apart.\n"
          "2. Turn right foot out 90 degrees and left foot slightly in.\n"
          "3. Bend the right knee and extend arms parallel to the floor.\n"
          "4. Gaze forward over right hand.\n"
          "5. Hold for 20–40 seconds, then repeat on other side.",
      advantages:
      "• Strengthens legs, arms, and core.\n"
          "• Improves balance and stability.\n"
          "• Energizes the body and mind.\n"
          "• Boosts self-confidence.",
      history:
      "Named after Virabhadra, a fierce warrior from Hindu mythology, this pose embodies courage and focus.",
    ),
    Exercise(
      title: "Vrikshasana (Tree Pose)",
      image: "assets/exercises/happy/vrikshasana.png",
      description:
      "Vrikshasana, or Tree Pose, is a balancing posture that mimics the steady stance of a tree, fostering stability and calm.",
      technique:
      "1. Stand tall with feet together.\n"
          "2. Place right foot on inner left thigh.\n"
          "3. Bring palms together in front of chest or raise arms overhead.\n"
          "4. Balance on one leg for 30–60 seconds.\n"
          "5. Repeat with the other leg.",
      advantages:
      "• Improves balance and concentration.\n"
          "• Strengthens legs and spine.\n"
          "• Calms the mind and reduces anxiety.\n"
          "• Enhances posture and body awareness.",
      history:
      "From Sanskrit 'Vriksha' (tree), this asana has been practiced in yoga traditions for centuries to cultivate stillness and groundedness.",
    ),
  ],

  // ------------------- ANGRY -------------------
  "angry": [
    Exercise(
      title: "Balasana (Child's Pose)",
      image: "assets/exercises/angry/balasana.png",
      description:
      "Balasana is a gentle resting pose that relaxes the body and mind, often used to relieve tension and stress.",
      technique:
      "1. Kneel on the mat and touch your big toes together.\n"
          "2. Sit back on your heels and fold forward, extending arms in front or beside your body.\n"
          "3. Rest forehead on the mat.\n"
          "4. Hold for 1–3 minutes, breathing slowly and deeply.",
      advantages:
      "• Reduces stress and fatigue.\n"
          "• Stretches hips, thighs, and ankles.\n"
          "• Calms the mind and relieves tension.",
      history:
      "Balasana is a traditional Hatha Yoga pose commonly used in sequences to rest between more demanding asanas.",
    ),
    Exercise(
      title: "Marjaryasana-Bitilasana (Cat-Cow Pose)",
      image: "assets/exercises/angry/marjaryasana_bitilasana.png",
      description:
      "A gentle flow between Cat and Cow poses to increase flexibility and release tension along the spine.",
      technique:
      "1. Begin on all fours with hands under shoulders and knees under hips.\n"
          "2. Inhale, drop belly, lift tailbone and head (Cow Pose).\n"
          "3. Exhale, round spine, tuck chin (Cat Pose).\n"
          "4. Repeat 10–15 cycles slowly.",
      advantages:
      "• Improves spinal flexibility.\n"
          "• Relieves tension in neck, back, and shoulders.\n"
          "• Massages organs and improves circulation.",
      history:
      "This flow is rooted in Hatha Yoga to cultivate awareness of breath and body alignment.",
    ),
    Exercise(
      title: "Nadi Shodhana (Alternate Nostril Breathing)",
      image: "assets/exercises/angry/nadi_shodhana.png",
      description:
      "A calming pranayama technique to balance energy and reduce anger or stress.",
      technique:
      "1. Sit comfortably with a straight spine.\n"
          "2. Use right thumb to close right nostril.\n"
          "3. Inhale through left nostril.\n"
          "4. Close left nostril with ring finger and exhale through right nostril.\n"
          "5. Inhale through right, exhale left; continue for 5–10 minutes.",
      advantages:
      "• Reduces stress and anxiety.\n"
          "• Balances nervous system and energy channels.\n"
          "• Promotes mental clarity and emotional stability.",
      history:
      "Nadi Shodhana is an ancient pranayama from classical yoga texts to purify 'nadis' (energy channels).",
    ),
    Exercise(
      title: "Uttanasana (Standing Forward Bend)",
      image: "assets/exercises/angry/uttanasana.png",
      description:
      "A forward bend that stretches the spine and hamstrings while calming the mind.",
      technique:
      "1. Stand with feet hip-width apart.\n"
          "2. Exhale and fold forward from the hips.\n"
          "3. Let head and neck relax.\n"
          "4. Hold for 30–60 seconds, gently sway if needed.",
      advantages:
      "• Stretches hamstrings, calves, and spine.\n"
          "• Calms the mind and relieves stress.\n"
          "• Stimulates liver and kidneys.",
      history:
      "Uttanasana is a classic Hatha Yoga asana known for grounding and relieving agitation.",
    ),
    Exercise(
      title: "Viparita Karani (Legs-Up-The-Wall Pose)",
      image: "assets/exercises/angry/viparita_karani.png",
      description:
      "A restorative pose that helps calm the mind and reduce anger by promoting relaxation.",
      technique:
      "1. Sit sideways near a wall.\n"
          "2. Swing legs up the wall as you lie on your back.\n"
          "3. Relax arms by your side and breathe deeply.\n"
          "4. Hold for 5–15 minutes.",
      advantages:
      "• Reduces stress and mild anxiety.\n"
          "• Improves circulation and relieves leg fatigue.\n"
          "• Calms nervous system.",
      history:
      "Viparita Karani is a traditional restorative asana used to rejuvenate the body and mind.",
    ),
  ],

  // ------------------- SAD -------------------
  "sad": [
    Exercise(
      title: "Matsyasana (Fish Pose)",
      image: "assets/exercises/sad/matsyasana.png",
      description:
      "Matsyasana opens the chest and throat, helping to lift mood and energy levels.",
      technique:
      "1. Lie on your back, legs extended.\n"
          "2. Place hands under hips, palms down.\n"
          "3. Inhale, lift chest and head backward.\n"
          "4. Crown of head rests gently on the floor.\n"
          "5. Hold 20–40 seconds, breathe deeply.",
      advantages:
      "• Opens chest and lungs, aiding respiration.\n"
          "• Relieves mild depression and fatigue.\n"
          "• Stretches throat and spine.",
      history:
      "Matsyasana, 'Fish Pose,' is a traditional yoga posture that stimulates energy flow and relieves lethargy.",
    ),
    Exercise(
      title: "Paschimottanasana (Seated Forward Bend)",
      image: "assets/exercises/sad/paschimottanasana.png",
      description:
      "A calming forward bend that stretches the spine and hamstrings while soothing the mind.",
      technique:
      "1. Sit with legs extended.\n"
          "2. Inhale, lengthen spine.\n"
          "3. Exhale, bend forward and reach for feet or shins.\n"
          "4. Hold 30–60 seconds, breathe evenly.",
      advantages:
      "• Stretches spine, shoulders, and hamstrings.\n"
          "• Reduces stress and mild depression.\n"
          "• Stimulates liver and kidneys.",
      history:
      "A foundational Hatha Yoga posture known for calming the nervous system.",
    ),
    Exercise(
      title: "Supta Baddha Konasana (Reclining Bound Angle Pose)",
      image: "assets/exercises/sad/supta_baddha_konasana.png",
      description:
      "A restorative pose that opens hips and promotes relaxation.",
      technique:
      "1. Lie on back.\n"
          "2. Bring soles of feet together, knees out to sides.\n"
          "3. Rest arms by your sides.\n"
          "4. Hold 2–5 minutes, breathing deeply.",
      advantages:
      "• Opens hips and groin.\n"
          "• Relieves anxiety and mild depression.\n"
          "• Promotes deep relaxation.",
      history:
      "Supta Baddha Konasana has long been used in yoga for restorative and meditative purposes.",
    ),
    Exercise(
      title: "Ustrasana (Camel Pose)",
      image: "assets/exercises/sad/ustrasana.png",
      description:
      "A backbend that opens the chest, uplifts mood, and stimulates energy.",
      technique:
      "1. Kneel on mat, knees hip-width apart.\n"
          "2. Place hands on heels.\n"
          "3. Inhale, arch spine, drop head gently.\n"
          "4. Hold 20–40 seconds, breathe evenly.",
      advantages:
      "• Improves spinal flexibility.\n"
          "• Opens chest and lungs.\n"
          "• Reduces fatigue and mild depression.",
      history:
      "Traditional Hatha Yoga posture to open heart and energize the body.",
    ),
    Exercise(
      title: "Viparita Karani (Legs-Up-The-Wall Pose)",
      image: "assets/exercises/sad/viparita_karani.png",
      description:
      "Restorative pose that promotes calmness and helps uplift mood.",
      technique:
      "1. Sit near a wall.\n"
          "2. Lie back and lift legs up the wall.\n"
          "3. Relax arms, breathe deeply.\n"
          "4. Hold 5–15 minutes.",
      advantages:
      "• Reduces stress and mild depression.\n"
          "• Improves circulation.\n"
          "• Promotes relaxation.",
      history:
      "Used traditionally in yoga to restore energy and calm the mind.",
    ),
  ],

  // ------------------- NEUTRAL -------------------
  "neutral": [
    Exercise(
      title: "Ardha Chandrasana (Half Moon Pose)",
      image: "assets/exercises/neutral/ardha_chandrasana.png",
      description:
      "A balancing posture that strengthens the legs and core, while improving focus.",
      technique:
      "1. Stand in Triangle Pose, then shift weight onto front foot.\n"
          "2. Lift back leg parallel to floor.\n"
          "3. Extend top arm toward ceiling, gaze upward.\n"
          "4. Hold 20–30 seconds per side.",
      advantages:
      "• Improves balance and coordination.\n"
          "• Strengthens legs, core, and spine.\n"
          "• Enhances focus and concentration.",
      history:
      "Ardha Chandrasana, 'Half Moon,' is a classical yoga pose that develops stability and poise.",
    ),
    Exercise(
      title: "Marjaryasana-Bitilasana (Cat-Cow Pose)",
      image: "assets/exercises/neutral/marjaryasana_bitilasana.png",
      description:
      "Gentle flow to increase spinal flexibility and body awareness.",
      technique:
      "1. Begin on all fours.\n"
          "2. Inhale into Cow Pose (belly down).\n"
          "3. Exhale into Cat Pose (spine rounded).\n"
          "4. Repeat 10–15 cycles.",
      advantages:
      "• Improves spine mobility.\n"
          "• Reduces tension in neck and back.\n"
          "• Promotes mindfulness and breathing awareness.",
      history:
      "Ancient Hatha Yoga practice to harmonize breath with movement.",
    ),
    Exercise(
      title: "Meditation (Dhyana)",
      image: "assets/exercises/neutral/meditation.png",
      description:
      "Practice of quieting the mind to improve awareness and emotional balance.",
      technique:
      "1. Sit comfortably with spine straight.\n"
          "2. Close eyes, focus on breath.\n"
          "3. Let thoughts pass without attachment.\n"
          "4. Practice for 10–20 minutes daily.",
      advantages:
      "• Improves focus and mental clarity.\n"
          "• Reduces stress and anxiety.\n"
          "• Enhances emotional stability.",
      history:
      "Meditation has been a core practice in yoga and spiritual traditions for thousands of years.",
    ),
    Exercise(
      title: "Sukhasana (Easy Pose)",
      image: "assets/exercises/neutral/sukhasana.png",
      description:
      "Simple seated posture to promote calmness and focus.",
      technique:
      "1. Sit cross-legged on floor or mat.\n"
          "2. Keep spine straight, hands on knees.\n"
          "3. Relax shoulders and breathe deeply.\n"
          "4. Hold 5–15 minutes.",
      advantages:
      "• Improves posture and alignment.\n"
          "• Promotes calm and focus.\n"
          "• Prepares body for meditation or pranayama.",
      history:
      "Sukhasana is a foundational pose in yoga for meditation and relaxation.",
    ),
    Exercise(
      title: "Tadasana (Mountain Pose)",
      image: "assets/exercises/neutral/tadasana.png",
      description:
      "A foundational standing posture promoting alignment and awareness.",
      technique:
      "1. Stand with feet together, arms by side.\n"
          "2. Engage legs, lift chest, lengthen spine.\n"
          "3. Balance weight evenly, breathe deeply.\n"
          "4. Hold 30–60 seconds.",
      advantages:
      "• Improves posture and balance.\n"
          "• Strengthens legs and core.\n"
          "• Increases awareness and grounding.",
      history:
      "Tadasana is a classical yoga posture serving as the base for many standing asanas.",
    ),
  ],

  // ------------------- ANXIOUS -------------------
  "anxious": [
    Exercise(
      title: "Breathing Exercise (Pranayama)",
      image: "assets/exercises/anxious/breathing.png",
      description:
      "Simple breathing exercise to relieve tension and anxiety.",
      technique:
      "1. Sit comfortably, spine straight.\n"
          "2. Inhale deeply through nose.\n"
          "3. Exhale slowly through mouth.\n"
          "4. Repeat 10–15 times, focusing on breath.",
      advantages:
      "• Calms the mind.\n"
          "• Reduces heart rate and stress.\n"
          "• Improves oxygen flow.",
      history:
      "Breathing exercises are core in yoga to harmonize mind and body.",
    ),
    Exercise(
      title: "Paschimottanasana (Seated Forward Bend)",
      image: "assets/exercises/anxious/paschimottanasana.png",
      description:
      "Forward bend to release tension and calm anxiety.",
      technique:
      "1. Sit with legs extended.\n"
          "2. Inhale, lengthen spine.\n"
          "3. Exhale, fold forward, reach feet.\n"
          "4. Hold 30–60 seconds.",
      advantages:
      "• Stretches spine and hamstrings.\n"
          "• Relieves stress and mild anxiety.\n"
          "• Promotes relaxation.",
      history:
      "Ancient Hatha Yoga posture used for calming the nervous system.",
    ),
    Exercise(
      title: "Utthita Trikonasana (Extended Triangle Pose)",
      image: "assets/exercises/anxious/utthita_trikonasana.png",
      description:
      "Standing posture improving balance, flexibility, and mental focus.",
      technique:
      "1. Stand with feet wide apart.\n"
          "2. Turn right foot out 90°, left foot slightly in.\n"
          "3. Extend arms parallel to floor.\n"
          "4. Bend over right leg, touch foot or shin, gaze up.\n"
          "5. Hold 20–40 seconds each side.",
      advantages:
      "• Stretches legs, hips, and spine.\n"
          "• Improves balance and stability.\n"
          "• Reduces anxiety and mental stress.",
      history:
      "Classic yoga asana to develop strength, stability, and mental clarity.",
    ),
    Exercise(
      title: "Balasana (Child's Pose)",
      image: "assets/exercises/anxious/balasana.png",
      description:
      "Resting pose to calm the mind and relieve anxiety.",
      technique:
      "1. Kneel and sit back on heels.\n"
          "2. Fold forward, arms extended or by sides.\n"
          "3. Rest forehead on mat.\n"
          "4. Hold 1–3 minutes, breathe slowly.",
      advantages:
      "• Reduces stress and anxiety.\n"
          "• Stretches back and hips.\n"
          "• Promotes relaxation.",
      history:
      "Traditional Hatha Yoga pose for resting and calming energy.",
    ),
    Exercise(
      title: "Viparita Karani (Legs-Up-The-Wall Pose)",
      image: "assets/exercises/anxious/viparita_karani.png",
      description:
      "Restorative pose to calm the nervous system and alleviate anxiety.",
      technique:
      "1. Sit near a wall, swing legs up.\n"
          "2. Lie back, arms relaxed.\n"
          "3. Breathe slowly for 5–15 minutes.",
      advantages:
      "• Reduces anxiety and stress.\n"
          "• Improves circulation.\n"
          "• Promotes mental calm and relaxation.",
      history:
      "Traditional restorative yoga posture for relaxation and rejuvenation.",
    ),
  ],
};
