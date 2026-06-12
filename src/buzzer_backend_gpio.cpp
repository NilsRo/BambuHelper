#include "buzzer_backend.h"
#include "buzzer.h"
#include "settings.h"

// I2S audio boards (ES8311 codec, NS4168 amp) have their own backends
#if !defined(BOARD_HAS_ES8311_AUDIO) && !defined(BOARD_HAS_NS4168_AUDIO)

void buzzerBackendInit() {
  sanitizeBuzzerPin();
  if (buzzerSettings.pin == 0) return;
  pinMode(buzzerSettings.pin, OUTPUT);
  digitalWrite(buzzerSettings.pin, LOW);
}

void buzzerBackendApplyStep(uint16_t freq) {
  if (buzzerSettings.pin == 0) return;
  if (freq > 0) {
    tone(buzzerSettings.pin, freq);
  } else {
    noTone(buzzerSettings.pin);
    digitalWrite(buzzerSettings.pin, LOW);
  }
}

void buzzerBackendStop() {
  sanitizeBuzzerPin();
  if (buzzerSettings.pin == 0) return;
  noTone(buzzerSettings.pin);
  digitalWrite(buzzerSettings.pin, LOW);
}

void buzzerBackendTick() {
}

void buzzerBackendShutdown() {
  buzzerBackendStop();
}

#endif // !BOARD_HAS_ES8311_AUDIO && !BOARD_HAS_NS4168_AUDIO
