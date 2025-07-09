import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text start
      children: [
        Text(
          'PromptShot is a curated gallery showcasing stunning AI-generated images created from creative prompts. Explore, download, and get inspired by the power of imagination combined with technology.',
          style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.5),
        ),
        SizedBox(height: 16),
        Text(
          'PromptShot ကတော့ စိတ်ကူးကောင်းတဲ့ စာသားလေးတွေ(prompts)ကနေ AI နဲ့ ဖန်တီးထားတဲ့ပုံလေးတွေကို စုစည်းပြသထားတဲ့ Gallery လေးပါ။ ဒီထဲမှာ ပုံလေးတွေကို လေ့လာကြည့်ရှုနိုင်သလို၊ ဒေါင်းလုဒ်လုပ်ပြီး စိတ်ကူးသစ်တွေလည်း ရယူနိုင်ပါတယ်။ နည်းပညာနဲ့ စိတ်ကူးစိတ်သန်းတွေ ပေါင်းစပ်လိုက်တဲ့အခါ ဘယ်လောက်အစွမ်းထက်လဲဆိုတာ ကိုယ်တိုင်တွေ့မြင်ခံစားကြည့်ပါဦးနော်။',
          style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.5),
        ),
      ],
    );
  }
}
