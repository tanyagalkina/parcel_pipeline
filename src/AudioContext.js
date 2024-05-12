


export const startAudioContext = () => {
const audioContext = new AudioContext();
const audio = new Audio("../../src/assets/click-button.mp3");
const source = audioContext.createMediaElementSource(audio);
source.connect(audioContext.destination);
return {
  audio,
  resumeAudio: async () => {
      if (audioContext.state === "suspended") {
          await audioContext.resume();
      }
      audio.play();
  }
};
// const resumeAudio = async () => {
//   if (audioContext.state === "suspended") {
//       await audioContext.resume();
//   }
//   audio.play(); // Start playing the audio
// };

// // If this code is running in a browser, you should call `resumeAudio` in response to a user gesture like a click or tap
// return { audio, resumeAudio };
}

// export const resumeAudio = () => resumeAudio();