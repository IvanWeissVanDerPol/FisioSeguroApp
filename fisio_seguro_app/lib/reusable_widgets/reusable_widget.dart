import 'package:fisio_seguro_app/themes/themes.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final String imageName;

  const LogoWidget({Key? key, required this.imageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageName,
      fit: BoxFit.fitWidth,
      width: 240,
      height: 240,
    );
  }
}

class ReusableElevatedButton extends StatelessWidget {
  final Icon icon;
  final String buttonText;
  final Function onTap;

  const ReusableElevatedButton({
    Key? key,
    required this.icon,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        color: AppGeneric.palleteColor_1,
      ),
      child: ElevatedButton.icon(
        onPressed: () => onTap(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppGeneric.palleteColor_1),
        ),
        icon: icon,
        label: Text(
          buttonText,
          style: const TextStyle(color: AppGeneric.text, fontSize: 16),
        ),
      ),
    );
  }
}

class FirebaseUIButton extends StatelessWidget {
  final String title;
  final Function onTap;

  const FirebaseUIButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        color: AppGeneric.palleteColor_1,
      ),
      child: ElevatedButton(
        onPressed: () => onTap(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppGeneric.palleteColor_1),
        ),
        child: Text(
          title,
          style: const TextStyle(color: AppGeneric.text, fontSize: 16),
        ),
      ),
    );
  }
}

class ReusableTextField extends StatelessWidget {
  final String hintText;
  final IconData leadingIcon;
  final bool isObscure;
  final TextEditingController controller;

  const ReusableTextField({
    Key? key,
    required this.hintText,
    required this.leadingIcon,
    required this.isObscure,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      enableSuggestions: !isObscure,
      autocorrect: !isObscure,
      decoration: InputDecoration(
        prefixIcon: Icon(
          leadingIcon,
          color: AppGeneric.iconColor,
        ),
        hintText: hintText,
        labelText: hintText,
        filled: true,
        fillColor: AppGeneric.palleteColor_1_light,
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      keyboardType: isObscure ? TextInputType.visiblePassword : TextInputType.emailAddress,
      style: const TextStyle(color: AppGeneric.text),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  const ActionCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: AppGeneric.palleteColor_1,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: AppGeneric.iconColor,
                  size: 40.0,
                ),
                Text(
                  title,
                  style: const TextStyle(color: AppGeneric.text, fontSize: 20),
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  style: const TextStyle(color: AppGeneric.text, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundGradient extends StatelessWidget {
  final Widget child;

  const BackgroundGradient({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppGeneric.linearGradient),
      child: child,
    );
  }
}
