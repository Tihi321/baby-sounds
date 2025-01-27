import '../models/audio_track.dart';
import '../services/audio_player_service.dart';

class TrackRepository {
  final AudioPlayerService audioService;

  TrackRepository(this.audioService);

  List<AudioTrack> getNoiseTracks() {
    return [
      AudioTrack(
        title: 'White Noise',
        assetPath: 'assets/audio/noise/white-noise.mp3',
        audioService: audioService,
      ),
      AudioTrack(
        title: 'Waves',
        assetPath: 'assets/audio/noise/waves-noise.mp3',
        audioService: audioService,
      ),
    ];
  }

  List<AudioTrack> getLullabyTracks() {
    return [
      AudioTrack(
        title: 'Calm Lullaby',
        assetPath: 'assets/audio/lullaby/calm-and-focused-lull.mp3',
        audioService: audioService,
      ),
      AudioTrack(
        title: 'Mozart Lullaby',
        assetPath: 'assets/audio/lullaby/mozart-brahms-lull.mp3',
        audioService: audioService,
      ),
      AudioTrack(
        title: 'Mozart Lullaby Second',
        assetPath: 'assets/audio/lullaby/mozart-brahms-sec-lull.mp3',
        audioService: audioService,
      ),
    ];
  }

  List<AudioTrack> getSongTracks() {
    return [
      AudioTrack(
        title: 'Cujem Te',
        assetPath: 'assets/audio/pjesme/cujem-te meri-jaman.mp3',
        audioService: audioService,
      ),
      AudioTrack(
        title: 'Cuvajmo Boje Vode',
        assetPath: 'assets/audio/pjesme/cuvajmo-boje-vode-jelena-radan.mp3',
        audioService: audioService,
      ),
      AudioTrack(
        title: 'Jedan Djecak',
        assetPath: 'assets/audio/pjesme/jedan-djecak-anita-valo.mp3',
        audioService: audioService,
      ),
      AudioTrack(
        title: 'Kuca Luda',
        assetPath: 'assets/audio/pjesme/kuca-luda.mp3',
        audioService: audioService,
      ),
      AudioTrack(
        title: 'Leti Poput Petra Pana',
        assetPath: 'assets/audio/pjesme/leti-poput-petra-pana-aljosa-seric.mp3',
        audioService: audioService,
      ),
      AudioTrack(
        title: 'Mjesto Za Mene',
        assetPath:
            'assets/audio/pjesme/mjesto-za-mene-goran-boskovic-meri-jaman-jelena-radan.mp3',
        audioService: audioService,
      ),
      AudioTrack(
        title: 'Place For Us',
        assetPath:
            'assets/audio/pjesme/place-for-us-goran-boskovic-meri-jaman-jelena-radan.mp3',
        audioService: audioService,
      ),
      AudioTrack(
        title: 'Rejna',
        assetPath: 'assets/audio/pjesme/rejna-viktorija-novosel.mp3',
        audioService: audioService,
      ),
    ];
  }
}
