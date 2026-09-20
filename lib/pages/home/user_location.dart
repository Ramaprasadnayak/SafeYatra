import 'package:flutter/material.dart';

class UserLocation extends StatefulWidget {
  final String? nation, city, district, state;
  final VoidCallback? onChange;
  const UserLocation({
    super.key,
    required this.city,
    required this.state,
    required this.district,
    required this.nation,
    required this.onChange,
  });

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 7, right: 7, top: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF1E4878),
                        Color(0xFF14234B),
                        Color(0xFF1F142D),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(Icons.location_on, color: Colors.white),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Current Location",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        // color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      widget.city ?? "Your city",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.district ?? "Your district",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        // color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_city_sharp,
                          size: 13,
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white60,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "${widget.state}, ${widget.nation}",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Colors.white60,
                                fontSize: 13,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 120,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF102242),
                  padding: EdgeInsets.zero,
                ),
                onPressed: widget.onChange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.my_location,
                      size: 12,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Update Location",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
