import 'package:flutter/material.dart';
import 'package:yes_no_app/infrastructure/datasources/yes_no_datasource.dart';
import 'package:yes_no_app/infrastructure/models/yes_no_model.dart';

class GifSelector extends StatefulWidget {
  final Function(String imageUrl) onGifSelected;

  const GifSelector({super.key, required this.onGifSelected});

  @override
  State<GifSelector> createState() => _GifSelectorState();
}

class _GifSelectorState extends State<GifSelector> {
  final YesNoDatasource _datasource = YesNoDatasource();
  bool _isLoading = false;
  List<YesNoModel> _gifs = [];

  Future<void> _loadGifs() async {
    setState(() => _isLoading = true);
    try {
      final List<Future<YesNoModel>> futures = List.generate(6, (_) => _datasource.getAnswer());
      _gifs = await Future.wait(futures);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading GIFs')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showGifPicker() {
    _loadGifs();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: 400,
              child: Column(
                children: [
                  const Text(
                    'Select a GIF',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _gifs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              widget.onGifSelected(_gifs[index].image);
                              Navigator.pop(context);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                _gifs[index].image,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      setModalState(() => _isLoading = true);
                      await _loadGifs();
                      setModalState(() => _isLoading = false);
                    },
                    child: const Text('Reload GIFs'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.gif_box_outlined, color: Colors.blueAccent, size: 30),
      onPressed: _showGifPicker,
      tooltip: 'Pick a GIF',
    );
  }
}
