export type Chapter = {
  file: string;
  slug: string;
  title: string;
  fromInclude?: boolean;
};

export type Course = {
  name: string;
  title: string;
  dir: string;
  noteChapters: Chapter[];
  practiceChapters: Chapter[];
};

// [Deprecated]: Will be removed in the future version.
export const COURSE_TITLES: Record<string, string> = {
  "Computer-Vision": "计算机视觉",
  "Natural-Language-Processing": "自然语言处理",
  "Signals-and-Systems": "信号与系统",
  "Computer-Network": "计算机网络",
  "Neuro-Network-and-Deep-Learning": "神经网络与深度学习",
  "Pattern-Recoginition-and-Machine-Learning": "模式识别与机器学习",
  "Control-Engineering": "控制工程",
  "Microcomputer": "微机原理",
  "Circuits-and-Electronics": "电路与电子学",
};
