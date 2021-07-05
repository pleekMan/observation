public class Timer {

    long savedTime;
    long totalTime;
    long currentTime;

    public Timer() {
      totalTime = 5000L ; // PREDETERMINADO
    }

    public void setDuration(int _duration) {
      totalTime = _duration;
    }

    public void setDurationInSeconds(int _durationInSeconds) {
      totalTime = _durationInSeconds * 1000;
    }

    public void start() {
      savedTime =  millis();
    }

    public boolean isFinished() {
      currentTime = millis() - savedTime;
      return currentTime > totalTime;
    }

    public int getTotalTime() {
      return (int)totalTime;
    }
    
    public int getTotalTimeInSeconds() {
      return   (int)(totalTime / 1000);
    }
    
    public int getCurrentTime() {
      return (int)currentTime;
    }
    public int getCurrentTimeInSeconds() {
      return (int)(currentTime / 1000);
    }
  }
