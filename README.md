# Rectifying and Processing EMG Signals in Simulink

## Project Overview  
This project demonstrates the processing of EMG (Electromyography) signals using Simulink. The workflow involves importing raw EMG data, filtering, rectifying, applying thresholds, and smoothing to obtain a clean signal for further analysis or control applications.

The project highlights essential signal processing techniques and tools within Simulink.

<img src="bio_image/circuit 3.png" alt="Boh" width="1200"/>

---

## Workflow Steps and Blocks

1. ### **From-Workspace Block**
   - **Purpose**: Imports EMG signal data from MATLAB workspace.  
   - **Note**: The EMG data (`ES2_emg`) must be formatted as a **struct** containing `time` and `signals` fields.  

2. ### **Demultiplexer**
   - **Purpose**: Splits the input matrix into 4 separate signals.  

3. ### **Discrete FIR Filter (Bandpass Filter)**
   - **Purpose**: Applies a **bandpass filter** to the signal to isolate the relevant EMG frequency components.  
   - **Configuration**:
     - Import the bandpass filter coefficients (`b`) into Simulink.

4. ### **Absolute Block**
   - **Purpose**: Rectifies the EMG signal by converting all values to their absolute magnitudes.

5. ### **Discrete FIR Filter (Lowpass Filter)**
   - **Purpose**: Applies a **lowpass filter** to smoothen the rectified signal.  
   - **Configuration**:
     - Import the lowpass filter coefficients (`lp_b`) into Simulink.

6. ### **Threshold Block**
   - **Purpose**: Implements a threshold function to highlight significant EMG activity.  
   - **Logic**:
     - If the signal > **70% of the maximum value**:  
       **Output = Signal itself**  
     - Otherwise:  
       **Output = 0**

7. ### **Smoothing Block**
   - **Purpose**: Converts the processed EMG signal from **discrete** to **continuous** for smooth visualization and analysis.

8. ### **Display (Visualization)**
   - **Purpose**: Visualizes the processed EMG signal and demonstrates the movement of a point toward desired targets based on the signal.

---

## Output Example

The processed EMG signal will show:  
- Cleaned, rectified, and smooth signal output.  
- Threshold-based activity highlighting.  
- Visualization of the point movement to desired targets.

---

## Author  
**Wadoud Guelmami**  

## Conclusion  
This project showcases a robust EMG signal processing pipeline in Simulink, integrating filtering, rectification, thresholding, and visualization techniques. It demonstrates expertise in **Simulink modeling**, **signal processing**, and **MATLAB integration**.

