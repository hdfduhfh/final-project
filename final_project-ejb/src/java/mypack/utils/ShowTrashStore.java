package mypack.utils;

import java.io.*;
import java.util.*;

public class ShowTrashStore {

    private static final String DIR_NAME = "bookingstage-trash";
    private static final String FILE_NAME = "show-trash.dat";
    private static final long DAYS_30_MS = 30L * 24 * 60 * 60 * 1000;

    private static File getStoreFile() throws IOException {
        File dir = new File(System.getProperty("user.home"), DIR_NAME);
        if (!dir.exists()) dir.mkdirs();

        File f = new File(dir, FILE_NAME);
        if (!f.exists()) f.createNewFile();
        return f;
    }

    /** Map<showId, deletedAtMillis> */
    public static synchronized Map<Integer, Long> readTrash() throws IOException {
        Map<Integer, Long> map = new HashMap<>();
        File f = getStoreFile();

        try (BufferedReader br = new BufferedReader(new FileReader(f))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                String[] p = line.split("\\|");
                if (p.length != 2) continue;

                try {
                    int id = Integer.parseInt(p[0].trim());
                    long deletedAt = Long.parseLong(p[1].trim());
                    map.put(id, deletedAt);
                } catch (Exception ignored) {}
            }
        }
        return map;
    }

    private static synchronized void writeTrash(Map<Integer, Long> map) throws IOException {
        File f = getStoreFile();
        try (PrintWriter pw = new PrintWriter(new FileWriter(f, false))) {
            for (Map.Entry<Integer, Long> e : map.entrySet()) {
                pw.println(e.getKey() + "|" + e.getValue());
            }
        }
    }

    public static synchronized void softDelete(int showId) throws IOException {
        Map<Integer, Long> map = readTrash();
        map.put(showId, System.currentTimeMillis());
        writeTrash(map);
    }

    public static synchronized void restore(int showId) throws IOException {
        Map<Integer, Long> map = readTrash();
        map.remove(showId);
        writeTrash(map);
    }

    /** Danh sách ID còn trong 30 ngày */
    public static synchronized Set<Integer> activeTrashIds() throws IOException {
        Map<Integer, Long> map = readTrash();
        Set<Integer> rs = new HashSet<>();
        long now = System.currentTimeMillis();

        for (Map.Entry<Integer, Long> e : map.entrySet()) {
            if (now - e.getValue() <= DAYS_30_MS) {
                rs.add(e.getKey());
            }
        }
        return rs;
    }

    /** Danh sách ID đã quá 30 ngày */
    public static synchronized List<Integer> expiredTrashIds() throws IOException {
        Map<Integer, Long> map = readTrash();
        List<Integer> rs = new ArrayList<>();
        long now = System.currentTimeMillis();

        for (Map.Entry<Integer, Long> e : map.entrySet()) {
            if (now - e.getValue() > DAYS_30_MS) {
                rs.add(e.getKey());
            }
        }
        return rs;
    }

    public static long getRetentionMs() {
        return DAYS_30_MS;
    }
}
