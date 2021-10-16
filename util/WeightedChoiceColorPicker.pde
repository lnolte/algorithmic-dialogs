// A Random Sampler for probabilistic color schemes

public class Element {
    protected double probability;
    protected color c;

    public Element(double probability, color c) {
        this.probability = probability;
        this.c = c;
    }
}

public class RandomSampler {
    private ArrayList<Element> elements;
    private int totalPro = 0;

    public RandomSampler(ArrayList<Element> elements) {
        this.elements = elements;
        for (Element element : elements) {
            totalPro += element.probability;
        }
    }

    public Element getRandom() {
        int index = int(random(totalPro));
        int sum = 0;
        int i = 0;
        while (sum < index) {
            sum += elements.get(i++).probability;
        }
        return elements.get(max(0, i-1));
    }
}