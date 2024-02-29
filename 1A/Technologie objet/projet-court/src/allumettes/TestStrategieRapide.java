package allumettes;

import org.junit.*;
import static org.junit.Assert.*;

/** Classe qui test la stratégie rapide.
 * @author bschloge
 */
public class TestStrategieRapide {

	public final static double EPSILON = 0.001;

	private Jeu jeu;
	private Strategie strat;
	private Joueur joueur;
	private int allumRes;

	@Before
	public void setUp() {
		jeu = new JeuProxy();
		strat = new StrategieRapide();
		joueur = new Joueur("joueurRapide", strat);
		allumRes = jeu.getNombreAllumettes();
	}

	@Test
	public void testInitialisation() {
		assertTrue("Définition de la stratégie", strat != null);
		assertTrue("Définition du jeu", jeu != null);
		assertTrue("Définition du joueur", joueur.getNom().equals("joueurRapide"));
		assertTrue("Définition du joueur", joueur.getStrat().equals(strat));
		assertEquals("Définition du nombre d'allumettes", allumRes, jeu.getNombreAllumettes());
	}

	@Test 
	public void testGetPrise() {
		for (int i = 3; i >= 0; i--) {
			assertEquals("Vérification du nombre prise : ", joueur.getPrise(jeu), 3, EPSILON);
			JeuAllumettes.nbAllumettes = JeuAllumettes.nbAllumettes - 3;
		}
		assertEquals("Vérification du nombre prise", joueur.getPrise(jeu), 1);

	}

}
