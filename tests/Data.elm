module Data exposing (..)


labeTestDoc : String
labeTestDoc =
    """
\\begin{equation}
\\label{foo}
{\\bf r}(t) = (x,y,z)(t)
\\end{equation}
"""


qftIntroText : String
qftIntroText =
    """

\\section{Introduction}


Quantum mechanics is the physical theory needed to understand atoms, electrons, and other tiny particles.  It answers questions such as these

* Why are atoms stable? According to classical electromagnetic theory, electrons whirling around the nucleus should radiate their energy way in the blink of an eye.

* Why atoms can form molecules.

* Why the spectrum of salt crystals dropped in a flame has bright lines.

To understand quantum mechanics, we need to understand why the classical theories of mechanics and optics cannot explain phenomena such as those listed above.  Despite the fact that they do not work in the quantum domain, they furnish a vocabulary of notions -- force, field, wave, conservation of momentum and energy, symmetry, and minimum principle -- from which one fashions a new language of wave packets and wave functions, operators and observables that form the core of quantum theory and quantum field theory.

We begin with the notion of trajectory in mechanics, then consider optical theories, beginning with Hero of Alexandria (c. AD 30), who explained the law of reflection via a minimum principle for light rays.  Much later came the formulation of Snell's law of refraction and Fermat's explanation of it via a principle of minimum time for rays.  The optical theories motivated physics to find a way of understanding minimum principles.  In 1788, Lagrange formulated his powerful Principle of Least Action. It appears again and again in the history of physics, including its key role in Richard Feynman's path integral approach to quantum field theory.

There is a second branch of the optics storyline.  It begins with Huygens' wave theory of the propagation of light (1670) and gains momentum as it is able to explain not only reflection and refraction, but also phenomena such as interference and diffraction which the ray and corpuscular theories could not.

\\section{Trajectories in classical mechanics}

In classical mechanics, which successfully deals with objects such as arrows, baseballs, airplanes, and planets, we are accustomed to the idea of a body moving along a trajectory

\\begin{equation}
\\label{foo}
{\\bf r}(t) = (x,y,z)(t)
\\end{equation}


From the trajectory are defined the velocity ${\\bf v}(t) = d{\\bf r}(t)/dt$ and the acceleration ${\\bf a}(t) = d{\\bf v}(t)/dt$.  And once these are given, we have Newton's second law, ${\\bf F} = m{\\bf a}$, where a force ${\\bf F}$ is applied to a body of mass $m$. To set the stage for later developments, recall that the momentum of a body is ${\\bf p} = m{\\bf v}$, so that Newton's law can be written

\\begin{equation}
\\frac{d{\\bf p}}{dt} = {\\bf F}
\\end{equation}

The rate of change of the "quantity of motion" is equal to the applied force.  Such is the basis of classical mechanics as bequeathed to us by Isaac Newton in his \\emph{Philosophiæ Naturalis Principia Mathematica} (1687)

\\section{Uncertainty Principle}

\\image{http://psurl.s3.amazonaws.com/images/jc/gaussian_distribution-57de.gif}{}{}

Alas, the notion of trajectory does not hold in quantum mechanics.  This is because of the uncertainty principle, which has to do with the fact that a particle such as an electron does not have a position in the classical sense, but rather is a fuzzy object whose extent is measured by a quantity $\\Delta x$. That is, we cannot say exactly where the electron is, but rather can say that it has a certain probability distribution of possible locations, as in the figure, with most of the probability concentrated in a region of width $\\Delta x$.  Later, when we have the language of wave packets and wave functions,  we will be able to give a better explanation.  The same considerations apply to the momentum, so we also have a quantity $\\Delta p$ which measures its "uncertainty."  The Heisenberg Uncertainty Principle asserts that the product of these quantities has a lower bound:

\\begin{equation}
  \\Delta x \\, \\Delta p \\ge \\frac{\\hbar}{2}
\\end{equation}
Here $\\hbar$ is the reduced Planck constant $h/2\\pi$.
Planck's constant itself is
\\begin{equation}
h = 6.6\\times 10^{-34}\\;\\text{Joule-sec}
\\end{equation}
It has the dimension of an _action_ and is the fundamental constant of quantum physics.

One sometimes says that $\\Delta x$ is the standard deviation in measurements of position of (say) a particle, and that $\\Delta p$ is the same for the momentum.  There is an element of truth to this if one thinks of a series of repeated experiments.  But the real truth lies deeper.  It has to do with the fuzziness mentioned above, and can only be properly stated in the language of wave packets.

You may say, OK, all that philosophy is fine, but let's rig thing so that $\\Delta x$ is so small that we might as well consider out particle to be a classical point particle.  But if $\\Delta x$ is very, very small, then the uncertainty principle ensures that $\\Delta p$ will be very, very large, as will be $\\Delta v = \\Delta p/m$.  In our attempt to recover a classical trajectory, we make $\\Delta p$ so large that the notion of a well defined velocity is meaningless. Thus, whatever the mathematical language of quantum mechanics is, it cannot be based on a function ${\\bf r}(t)$ which gives position and therefore also velocity ${\\bf r}(t)$ and momentum ${\\bf p}(t)$.



\\subsection{Thought experiment: electron in a small box}


Let's make a back of the envelope calculations for a little thought experiment on electrons.

We will confine an electron to a little box with the dimension of two Bohr radiii.  The Bohr radius, which has a value of $5.3\\times 10^{-11}\\; m$, is the theoretical radius of the hydrogen atom in Niels Bohr's successful first quantum theory.  Thus our box is roughly the size of an atom, with a dimension of $10^{-11}\\; m$ or one Angstrom.  The uncertainty principle tells us that if $\\Delta x$ is less than one Angstrom, then $\\Delta p$ is at least $5.9\\times 10^{-35}\\; \\text{kg-m/sec}$. We use this to compute the uncertainty in the kinetic energy using the relation

\\begin{equation}
  K.E. = \\frac{1}{2}\\;mv^2 = \\frac{p^2}{2m}
\\end{equation}

Thus $\\Delta E = (\\Delta p)^2/m = 1.6\\times 10^{-19}\\; \\text{Joules}$.

To understand the significance of the value just computed for $\\Delta E$, we compare it to the energy of the rest mass of an electron:

\\begin{equation}
E = mc^2
\\end{equation}

An electron has rest mass

\\begin{equation}
m_e = 9.1\\times 10^{-31}\\;\\text{kg}
\\end{equation}

Using  $c = 3\\times 10^8\\;\\text{m/sec}$ for the velocity of light, we find $E_{rest} = 8.2\\times 10^{-14}\\; \\text{Joules}$.  Thus $\\Delta E$ is small compared to $E_{rest}$.

What about the velocity?  If we make a straightforward classical computation, we find $\\Delta v = (\\Delta p)/m = 6000\\;\\text{m/s}$.  The electron  "can be moving pretty fast" and so does not have a very well localized momentum.

\\subsection{A smaller box}

Let us continue the thought experiment. This time, we will confine the electron to a box about the size of a proton, so that $\\Delta x = 10^{-15}\\;\\text{m}$.  Repeating the calculations, we find that $\\Delta p = 2.5\\times 10^{-20}\\;\\text{kg-m/s}$ and $\\Delta E = 7\\times 10^{-10}\\;\\text{Joules}$.  This time $\\Delta E$ is much, much larger than the rest mass. It is so large that some of that energy could be converted into the formation of new particles!  This is the phenomenon of _pair production_.  It actually happens, indeed, is happening all around us.

\\subsection{ Relativistic computations}

The large value for the uncertainty of the momentum implies a large value for the uncertainty in the velocity: $\\Delta v = (\\Delta p)/m = 2.7\\times 10^{10}\\;\\text{m/s}$.  This is much higher than the velocity of light and so our previous computation cannot be correct.  For a correct computation, we use the energy-moment relation of special relativity:

\\begin{equation}
 E^2 = (pc)^2 + ( mc^2 )^2
\\end{equation}

We will explain this later when when we review special relativity.  But for now, observe that the factors of $c$ and $c^2$ in the parentheses ensure that all terms on the right have the same dimension, namely energy.  Doing the computation, we find that

\\begin{equation}
(\\Delta E)^2 = 5.6\\times 10^{-23} + 6.7\\times 10^{-27}
\\end{equation}

Thus $\\Delta E \\sim 7.5\\times 10^{-12}$.  This value is about 100 times less than the one previously calculated, but is still about 100 times greater than the rest mass.  There is still enough energy for pair production.

\\subsection{Creation and annihllation}
Pair production is the domain of quantum field theory, which has built into the notion of fields of creation and annihilation operators $\\hat a^\\dagger$ and $\\hat a$.  We will, however, take things step by step, first studying these operators in the simplest possible context, that of a quantum-mechanical harmonic oscillator.  Next we will consider discrete but possibly infinite systems of oscillators, and lastly fields thereof.  In a certain sense, the universe is a vast collection of harmonic oscillators!

\\section{Optical Theories}

\\subsection{Hero's Law of Reflection}

\\image{http://psurl.s3.amazonaws.com/images/jc/reflection-78c7.jpg}{}{}

The Law of Reflection states that the angle of reflection is equal to the angle of incidence.  That is, $\\angle AMB = \\angle BMC$ as in the Figure.  The Law is due to to the mathematician Hero of Alexandria (c. 10 AD -- c. 70 AD).  In addition to stating the law, he gave an explanation of it in terms of a minimum principle: the path that a reflected ray AMC follows in passing from A to C is the one of shortest length.  Hero's argument is likely the first application of a minimum principle in physics, and thus the forerunner of the Lagrangian approach to mechanics.

\\image{http://psurl.s3.amazonaws.com/images/jc/hero_reflection_1-7f3c.jpg}{}{}

Here is a possible reconstruction of his argument.  Consider
paths $ARB$ and $ASB$.  Assume that
$\\angle ARX \\cong BRY$, that is, that that the angle
of incidence is equal to the angle of reflection.  Construct a perpendicular to $XY$ passing through $B$. Let
$F$ be the foot of the perpendicular on $XY$ and let $C$ be the point on the perpendicular opposite to $B$ such that
$CF \\cong BF$. Then $\\triangle BRF \\cong \\triangle CRF$ and so $RB \\cong RC$.  Therefore the paths $ARB$ and $ARC$ have the same length.  The same reasoning shows that the paths $ASB$  and $ASC$ are of equal length.

For path $ARB$ one can make an additional assertion.
Since $\\triangle BRF \\cong \\triangle CRF$ , $\\angle CRF \\cong \\angle BRF$.
But then $\\angle CRF = \\angle ARX$ and so path $ARC$ is a
straight line.  It follows that $ARCS = ACS$ is a triangle, and that $AS + SC > AC$, where $AC = AR + RB$.

Q.E.D

One can prove the same result using calculus, albeit by a less elegant argument.


\\subsection{Snell's Law of Refraction}

\\image{http://psurl.s3.amazonaws.com/images/jc/index-of-refraction-30c1.jpg}{}{}


When a light ray crossed the boundary between two media, it is bent with respect to the normal line, as in the figure. This phenomenon, known as _refraction_ is due to the fact that light travels at different speeds in different media.  The amount of bending is described by _Snell's Law_.  As in the Figure, let $\\theta_1$ be the angle between the incoming ray and the normal to the interface between the two media, and let $\\theta_2$ be the corresponding angle for the outgoing ray.  Snell's law states that the ratio of the sines of the angles for the two rays is equal to the ratios of the velocities of light in the respective media:


\\begin{equation}
\\frac{\\sin \\theta_1}{\\sin \\theta_2} = \\frac{c_1}{c_2}
\\end{equation}

\\image{http://psurl.s3.amazonaws.com/images/jc/snell2-5b65.jpg}{}{}

Snell's Law can be rewritten as
$\\sin \\theta_2 = (c_2/c_1) \\sin \\theta_1$.  Thus, if the speed of light is lower in the second medium than in the first, the sine of the second angle will be less than the sine of the first angle. And since the sine is a strictly increasing function for angles less than $90^\\circ$, the second angle will be less than the first, as in the figure.


The speed of light in air is about 300,000 km/sec in air, 224,000 km/sec in water, and 200,000 km/sec in glass.  Using
$\\sin\\theta_2 = (c_2/c_1)\\sin\\theta_1$, we find that
$\\sin\\theta_2 =( 0.66)\\sin\\theta_1$ for transmission
from air to water and $\\sin\\theta_2 = (0.75)\\sin\\theta_1$
for air to ordinary glass.


\\image{http://psurl.s3.amazonaws.com/images/jc/fermat_principle-94da.jpg}{}{}

\\subsubsection{Fermat's principle}

Snell's Law is a consequence of Fermat's principle, which states that light rays travel in such a way that their time of transit from one point to another is minimized. To see that this is the case, the refracted ray ABC.  It originates at A, passes from one medium to another at B, and ends at C. We have

\\begin{equation}
AB = \\frac{h}{\\cos \\theta_1} \\qquad BC= \\frac{h}{\\cos \\theta_2}
\\end{equation}

so that the time of transit is

\\begin{equation}
t(\\theta_1, \\theta_2) = h\\left(
\\frac{1}{c_1\\cos\\theta_1}  + \\frac{1}{c_2\\cos\\theta_2} \\right)
\\end{equation}

It is subject to the constraint

\\begin{equation}
f(\\theta_1, \\theta_2)  = h(\\tan\\theta_1 + \\tan\\theta_2) = L
\\end{equation}



The method of Lagrange multipliers tells us that the minimum is found by solving the equation $\\nabla t = \\lambda \\nabla f$.  At a point which solves the Lagrange equation, the gradient of $t$ is normal to the surface and hence the rate of change in all directions is zero. One has

\\begin{equation}
\\nabla t = h\\left(\\frac{\\sin \\theta_1}{c_1 \\cos^2 \\theta_1},
\\frac{\\sin \\theta_2}{c_2 \\cos^2 \\theta_2}\\right)
\\end{equation}

and

\\begin{equation}
\\nabla f = h\\left(\\frac{1}{\\cos^2 \\theta_1},
\\frac{1}{\\cos^2 \\theta_2}\\right)
\\end{equation}

From these the relation follows.

.References
xref::60[[1]] *Snells' Law via Quantum Mechanics*. An explanation of Snell's law based on
the conservation of photon momentum.


\\subsection{Snell's Law and Huygen's Principle}

\\image{http://psurl.s3.amazonaws.com/images/jc/huygens_refraction2-1690.png}{}{}


Since ancient times (vide xref::61[Hero]), the operating model for understanding light had been the ray.  Closely related was Newton's corpuscular theory, in which a beam of light is a stream of particles.  One can think of rays as the trajectories of the particles.
In his work _Traité sur la Lumière_ (1690), Christian Huygens proposed a  wave theory of light. The basic idea was that of a spherical wave emanating from a point source.  In his _Traité_, Huygens takes inspiration from the circular waves emanating from the point in a pond where a pebble is dropped.  The rays are still there in the form of lines orthogonal to the circular wavefronts.  From this point of view, a beam of parallel rays is a train of rectilinear wave fronts, as in the Figure above.  In 3-space, one therefore has a train of parallel planes which mark the zones of maximum amplitude of the waves.

How do plane waves arise if waves are created by point sources?  One answer is that at great distances from the source, the concentric spheres of maximum intensity are very nearly flat, or planar. Such is the case for the light which comes to us from the sun.  Another answer is that a line of point sources in two dimensions, or a plane in three dimensions creates plane waves by superposition -- also as illustrated in the figure. The planar wave fronts are tangent to the circular wave fronts.  Consider the path AB. It consists of ten equally spaced wavefronts.  Consider also the path CDE. It also consists of ten equally spaced wave fronts. However, the spacing is narrower for DE since the velocity of light is lower in the second medium.  One could perform the same construction for other rays in the diagram, generating a spherical wave when the wave front strikes the interface DB. The outgoing plane waves are tangent to the circular/spherical wave fronts generated at the interface, where one must take care to match up wave fronts that correspond to equal times of transit.

\\image{http://psurl.s3.amazonaws.com/images/jc/huygens_snell-5ae9.jpg}{}{}

The foregoing gives a qualitative explanation of refraction which includes the prediction that waves entering a denser medium are bent towards the normal. However, Huygen's went further to derive Snell's law.  Consider a train of plane waves orthogonal to the parallel lines $BD$ and $AG$.  The wave front strikes the interface $GD$ and propagates from it via emission of spherical waves from point sources.  Because outgoing wave fronts are surfaces corresponding to equal transit times, the time of transit for $CD$ is equal to that of $GE$.  That is, $CD= c_1T$ and $GE = c_2T$, where $c_1$ is the velocity of light in the upper medium and $c_2$ is the velocity in the lower medium.  Thus

\\begin{equation}
\\frac{GE}{CD} = \\frac{c_2}{c_1}
\\end{equation}

Next observer that the angle of incidence $\\theta_1$ is $\\angle AGB$ and that the angle of refraction $\\theta_2$ is $\\angle FGE$. One finds that $\\theta_1 = \\angle CGD$ and $\\theta_2 = \\angle GDE$.  Now $\\sin \\theta_1 = CD/GD$ and $\\sin\\theta_2 = GE/GD$.  Therefore

\\begin{equation}
\\frac{GE}{CD} = \\frac{\\sin\\theta_2}{\\sin\\theta_1}
\\end{equation}

Comparing the displayed equations, we find that

\\begin{equation}
\\frac{\\sin\\theta_2}{\\sin\\theta_1} = \\frac{c_2}{c_1}
\\end{equation}

Q.E.D.


\\subsection{Snell's Law via Quantum Mechanics}

Snell's Law was introduced in xref::59[[1]], where it was explained as a result of Fermat's principle of least time.  There is also a quantum-mechanical explanation based on the the principle of conservation of momentum for photons.
The starting point is the deBroglie relation, which relates particle momentum $p$ to wavelength $\\lambda$:

\\begin{equation}
p = h/\\lambda
\\end{equation}

Here $h$ is Planck's constant, $6.6\\times 10^{-34}$ Joule-sec.  For a wave propagating with speed $c$, one has $c = \\lambda\\nu$, where $\\nu$ is the frequency.  Thus one can rewrite the de Broglie relation as

\\begin{equation}
  p = \\frac{h\\nu}{c}
\\end{equation}


\\emph{The argument}

In  (<<debroglie2>>), $p$ stands for the magnitude of the momentum vector
$\\vec p$. Since momentum is a vector quantity, it is
conserved componentwise.  Therefore, if $\\vec p$ is the
momentum in the first medium and $\\vec p'$  is
the momentum in the second, we have $p_x = p'_x$ for the
$x$ component. By trigonometry, this reads $p\\sin\\theta_1 = p\\sin\\theta_2$  Using (<<debroglie2>>) and trigonometry, we
have

\\begin{equation}
\\frac{h\\nu}{c_1}\\;\\sin \\theta_1
=
\\frac{h \\nu}{c_2}\\;\\sin \\theta_2
\\end{equation}

Simplifying, we have Snell's law:

\\begin{equation}
\\frac{\\sin \\theta_1}{\\sin \\theta_2}
=
\\frac{c_1}{c_2}
\\end{equation}

.References
xref::59[[1]] *Snell's Law*.  Statement of Snell's law and derivation from Fermat's principle of least action.

"""


{-| Thus -> Thusssss
-}
qftIntroText2 =
    """

\\section{Introduction}


Quantum mechanics is the physical theory needed to understand atoms, electrons, and other tiny particles.  It answers questions such as these

* Why are atoms stable? According to classical electromagnetic theory, electrons whirling around the nucleus should radiate their energy way in the blink of an eye.

* Why atoms can form molecules.

* Why the spectrum of salt crystals dropped in a flame has bright lines.

To understand quantum mechanics, we need to understand why the classical theories of mechanics and optics cannot explain phenomena such as those listed above.  Despite the fact that they do not work in the quantum domain, they furnish a vocabulary of notions -- force, field, wave, conservation of momentum and energy, symmetry, and minimum principle -- from which one fashions a new language of wave packets and wave functions, operators and observables that form the core of quantum theory and quantum field theory.

We begin with the notion of trajectory in mechanics, then consider optical theories, beginning with Hero of Alexandria (c. AD 30), who explained the law of reflection via a minimum principle for light rays.  Much later came the formulation of Snell's law of refraction and Fermat's explanation of it via a principle of minimum time for rays.  The optical theories motivated physics to find a way of understanding minimum principles.  In 1788, Lagrange formulated his powerful Principle of Least Action. It appears again and again in the history of physics, including its key role in Richard Feynman's path integral approach to quantum field theory.

There is a second branch of the optics storyline.  It begins with Huygens' wave theory of the propagation of light (1670) and gains momentum as it is able to explain not only reflection and refraction, but also phenomena such as interference and diffraction which the ray and corpuscular theories could not.

\\section{Trajectories in classical mechanics}

In classical mechanics, which successfully deals with objects such as arrows, baseballs, airplanes, and planets, we are accustomed to the idea of a body moving along a trajectory

\\begin{equation}
\\label{foo}
{\\bf r}(t) = (x,y,z)(t)
\\end{equation}


From the trajectory are defined the velocity ${\\bf v}(t) = d{\\bf r}(t)/dt$ and the acceleration ${\\bf a}(t) = d{\\bf v}(t)/dt$.  And once these are given, we have Newton's second law, ${\\bf F} = m{\\bf a}$, where a force ${\\bf F}$ is applied to a body of mass $m$. To set the stage for later developments, recall that the momentum of a body is ${\\bf p} = m{\\bf v}$, so that Newton's law can be written

\\begin{equation}
\\frac{d{\\bf p}}{dt} = {\\bf F}
\\end{equation}

The rate of change of the "quantity of motion" is equal to the applied force.  Such is the basis of classical mechanics as bequeathed to us by Isaac Newton in his \\emph{Philosophiæ Naturalis Principia Mathematica} (1687)

\\section{Uncertainty Principle}

\\image{http://psurl.s3.amazonaws.com/images/jc/gaussian_distribution-57de.gif}{}{}

Alas, the notion of trajectory does not hold in quantum mechanics.  This is because of the uncertainty principle, which has to do with the fact that a particle such as an electron does not have a position in the classical sense, but rather is a fuzzy object whose extent is measured by a quantity $\\Delta x$. That is, we cannot say exactly where the electron is, but rather can say that it has a certain probability distribution of possible locations, as in the figure, with most of the probability concentrated in a region of width $\\Delta x$.  Later, when we have the language of wave packets and wave functions,  we will be able to give a better explanation.  The same considerations apply to the momentum, so we also have a quantity $\\Delta p$ which measures its "uncertainty."  The Heisenberg Uncertainty Principle asserts that the product of these quantities has a lower bound:

\\begin{equation}
  \\Delta x \\, \\Delta p \\ge \\frac{\\hbar}{2}
\\end{equation}
Here $\\hbar$ is the reduced Planck constant $h/2\\pi$.
Planck's constant itself is
\\begin{equation}
h = 6.6\\times 10^{-34}\\;\\text{Joule-sec}
\\end{equation}
It has the dimension of an _action_ and is the fundamental constant of quantum physics.

One sometimes says that $\\Delta x$ is the standard deviation in measurements of position of (say) a particle, and that $\\Delta p$ is the same for the momentum.  There is an element of truth to this if one thinks of a series of repeated experiments.  But the real truth lies deeper.  It has to do with the fuzziness mentioned above, and can only be properly stated in the language of wave packets.

You may say, OK, all that philosophy is fine, but let's rig thing so that $\\Delta x$ is so small that we might as well consider out particle to be a classical point particle.  But if $\\Delta x$ is very, very small, then the uncertainty principle ensures that $\\Delta p$ will be very, very large, as will be $\\Delta v = \\Delta p/m$.  In our attempt to recover a classical trajectory, we make $\\Delta p$ so large that the notion of a well defined velocity is meaningless. Thus, whatever the mathematical language of quantum mechanics is, it cannot be based on a function ${\\bf r}(t)$ which gives position and therefore also velocity ${\\bf r}(t)$ and momentum ${\\bf p}(t)$.



\\subsection{Thought experiment: electron in a small box}


Let's make a back of the envelope calculations for a little thought experiment on electrons.

We will confine an electron to a little box with the dimension of two Bohr radiii.  The Bohr radius, which has a value of $5.3\\times 10^{-11}\\; m$, is the theoretical radius of the hydrogen atom in Niels Bohr's successful first quantum theory.  Thus our box is roughly the size of an atom, with a dimension of $10^{-11}\\; m$ or one Angstrom.  The uncertainty principle tells us that if $\\Delta x$ is less than one Angstrom, then $\\Delta p$ is at least $5.9\\times 10^{-35}\\; \\text{kg-m/sec}$. We use this to compute the uncertainty in the kinetic energy using the relation

\\begin{equation}
  K.E. = \\frac{1}{2}\\;mv^2 = \\frac{p^2}{2m}
\\end{equation}

Thus $\\Delta E = (\\Delta p)^2/m = 1.6\\times 10^{-19}\\; \\text{Joules}$.

To understand the significance of the value just computed for $\\Delta E$, we compare it to the energy of the rest mass of an electron:

\\begin{equation}
E = mc^2
\\end{equation}

An electron has rest mass

\\begin{equation}
m_e = 9.1\\times 10^{-31}\\;\\text{kg}
\\end{equation}

Using  $c = 3\\times 10^8\\;\\text{m/sec}$ for the velocity of light, we find $E_{rest} = 8.2\\times 10^{-14}\\; \\text{Joules}$.  Thus $\\Delta E$ is small compared to $E_{rest}$.

What about the velocity?  If we make a straightforward classical computation, we find $\\Delta v = (\\Delta p)/m = 6000\\;\\text{m/s}$.  The electron  "can be moving pretty fast" and so does not have a very well localized momentum.

\\subsection{A smaller box}

Let us continue the thought experiment. This time, we will confine the electron to a box about the size of a proton, so that $\\Delta x = 10^{-15}\\;\\text{m}$.  Repeating the calculations, we find that $\\Delta p = 2.5\\times 10^{-20}\\;\\text{kg-m/s}$ and $\\Delta E = 7\\times 10^{-10}\\;\\text{Joules}$.  This time $\\Delta E$ is much, much larger than the rest mass. It is so large that some of that energy could be converted into the formation of new particles!  This is the phenomenon of _pair production_.  It actually happens, indeed, is happening all around us.

\\subsection{ Relativistic computations}

The large value for the uncertainty of the momentum implies a large value for the uncertainty in the velocity: $\\Delta v = (\\Delta p)/m = 2.7\\times 10^{10}\\;\\text{m/s}$.  This is much higher than the velocity of light and so our previous computation cannot be correct.  For a correct computation, we use the energy-moment relation of special relativity:

\\begin{equation}
 E^2 = (pc)^2 + ( mc^2 )^2
\\end{equation}

We will explain this later when when we review special relativity.  But for now, observe that the factors of $c$ and $c^2$ in the parentheses ensure that all terms on the right have the same dimension, namely energy.  Doing the computation, we find that

\\begin{equation}
(\\Delta E)^2 = 5.6\\times 10^{-23} + 6.7\\times 10^{-27}
\\end{equation}

Thus $\\Delta E \\sim 7.5\\times 10^{-12}$.  This value is about 100 times less than the one previously calculated, but is still about 100 times greater than the rest mass.  There is still enough energy for pair production.

\\subsection{Creation and annihllation}
Pair production is the domain of quantum field theory, which has built into the notion of fields of creation and annihilation operators $\\hat a^\\dagger$ and $\\hat a$.  We will, however, take things step by step, first studying these operators in the simplest possible context, that of a quantum-mechanical harmonic oscillator.  Next we will consider discrete but possibly infinite systems of oscillators, and lastly fields thereof.  In a certain sense, the universe is a vast collection of harmonic oscillators!

\\section{Optical Theories}

\\subsection{Hero's Law of Reflection}

\\image{http://psurl.s3.amazonaws.com/images/jc/reflection-78c7.jpg}{}{}

The Law of Reflection states that the angle of reflection is equal to the angle of incidence.  That is, $\\angle AMB = \\angle BMC$ as in the Figure.  The Law is due to to the mathematician Hero of Alexandria (c. 10 AD -- c. 70 AD).  In addition to stating the law, he gave an explanation of it in terms of a minimum principle: the path that a reflected ray AMC follows in passing from A to C is the one of shortest length.  Hero's argument is likely the first application of a minimum principle in physics, and thus the forerunner of the Lagrangian approach to mechanics.

\\image{http://psurl.s3.amazonaws.com/images/jc/hero_reflection_1-7f3c.jpg}{}{}

Here is a possible reconstruction of his argument.  Consider
paths $ARB$ and $ASB$.  Assume that
$\\angle ARX \\cong BRY$, that is, that that the angle
of incidence is equal to the angle of reflection.  Construct a perpendicular to $XY$ passing through $B$. Let
$F$ be the foot of the perpendicular on $XY$ and let $C$ be the point on the perpendicular opposite to $B$ such that
$CF \\cong BF$. Then $\\triangle BRF \\cong \\triangle CRF$ and so $RB \\cong RC$.  Therefore the paths $ARB$ and $ARC$ have the same length.  The same reasoning shows that the paths $ASB$  and $ASC$ are of equal length.

For path $ARB$ one can make an additional assertion.
Since $\\triangle BRF \\cong \\triangle CRF$ , $\\angle CRF \\cong \\angle BRF$.
But then $\\angle CRF = \\angle ARX$ and so path $ARC$ is a
straight line.  It follows that $ARCS = ACS$ is a triangle, and that $AS + SC > AC$, where $AC = AR + RB$.

Q.E.D

One can prove the same result using calculus, albeit by a less elegant argument.


\\subsection{Snell's Law of Refraction}

\\image{http://psurl.s3.amazonaws.com/images/jc/index-of-refraction-30c1.jpg}{}{}


When a light ray crossed the boundary between two media, it is bent with respect to the normal line, as in the figure. This phenomenon, known as _refraction_ is due to the fact that light travels at different speeds in different media.  The amount of bending is described by _Snell's Law_.  As in the Figure, let $\\theta_1$ be the angle between the incoming ray and the normal to the interface between the two media, and let $\\theta_2$ be the corresponding angle for the outgoing ray.  Snell's law states that the ratio of the sines of the angles for the two rays is equal to the ratios of the velocities of light in the respective media:


\\begin{equation}
\\frac{\\sin \\theta_1}{\\sin \\theta_2} = \\frac{c_1}{c_2}
\\end{equation}

\\image{http://psurl.s3.amazonaws.com/images/jc/snell2-5b65.jpg}{}{}

Snell's Law can be rewritten as
$\\sin \\theta_2 = (c_2/c_1) \\sin \\theta_1$.  Thusssss, if the speed of light is lower in the second medium than in the first, the sine of the second angle will be less than the sine of the first angle. And since the sine is a strictly increasing function for angles less than $90^\\circ$, the second angle will be less than the first, as in the figure.


The speed of light in air is about 300,000 km/sec in air, 224,000 km/sec in water, and 200,000 km/sec in glass.  Using
$\\sin\\theta_2 = (c_2/c_1)\\sin\\theta_1$, we find that
$\\sin\\theta_2 =( 0.66)\\sin\\theta_1$ for transmission
from air to water and $\\sin\\theta_2 = (0.75)\\sin\\theta_1$
for air to ordinary glass.


\\image{http://psurl.s3.amazonaws.com/images/jc/fermat_principle-94da.jpg}{}{}

\\subsubsection{Fermat's principle}

Snell's Law is a consequence of Fermat's principle, which states that light rays travel in such a way that their time of transit from one point to another is minimized. To see that this is the case, the refracted ray ABC.  It originates at A, passes from one medium to another at B, and ends at C. We have

\\begin{equation}
AB = \\frac{h}{\\cos \\theta_1} \\qquad BC= \\frac{h}{\\cos \\theta_2}
\\end{equation}

so that the time of transit is

\\begin{equation}
t(\\theta_1, \\theta_2) = h\\left(
\\frac{1}{c_1\\cos\\theta_1}  + \\frac{1}{c_2\\cos\\theta_2} \\right)
\\end{equation}

It is subject to the constraint

\\begin{equation}
f(\\theta_1, \\theta_2)  = h(\\tan\\theta_1 + \\tan\\theta_2) = L
\\end{equation}



The method of Lagrange multipliers tells us that the minimum is found by solving the equation $\\nabla t = \\lambda \\nabla f$.  At a point which solves the Lagrange equation, the gradient of $t$ is normal to the surface and hence the rate of change in all directions is zero. One has

\\begin{equation}
\\nabla t = h\\left(\\frac{\\sin \\theta_1}{c_1 \\cos^2 \\theta_1},
\\frac{\\sin \\theta_2}{c_2 \\cos^2 \\theta_2}\\right)
\\end{equation}

and

\\begin{equation}
\\nabla f = h\\left(\\frac{1}{\\cos^2 \\theta_1},
\\frac{1}{\\cos^2 \\theta_2}\\right)
\\end{equation}

From these the relation follows.

.References
xref::60[[1]] *Snells' Law via Quantum Mechanics*. An explanation of Snell's law based on
the conservation of photon momentum.


\\subsection{Snell's Law and Huygen's Principle}

\\image{http://psurl.s3.amazonaws.com/images/jc/huygens_refraction2-1690.png}{}{}


Since ancient times (vide xref::61[Hero]), the operating model for understanding light had been the ray.  Closely related was Newton's corpuscular theory, in which a beam of light is a stream of particles.  One can think of rays as the trajectories of the particles.
In his work _Traité sur la Lumière_ (1690), Christian Huygens proposed a  wave theory of light. The basic idea was that of a spherical wave emanating from a point source.  In his _Traité_, Huygens takes inspiration from the circular waves emanating from the point in a pond where a pebble is dropped.  The rays are still there in the form of lines orthogonal to the circular wavefronts.  From this point of view, a beam of parallel rays is a train of rectilinear wave fronts, as in the Figure above.  In 3-space, one therefore has a train of parallel planes which mark the zones of maximum amplitude of the waves.

How do plane waves arise if waves are created by point sources?  One answer is that at great distances from the source, the concentric spheres of maximum intensity are very nearly flat, or planar. Such is the case for the light which comes to us from the sun.  Another answer is that a line of point sources in two dimensions, or a plane in three dimensions creates plane waves by superposition -- also as illustrated in the figure. The planar wave fronts are tangent to the circular wave fronts.  Consider the path AB. It consists of ten equally spaced wavefronts.  Consider also the path CDE. It also consists of ten equally spaced wave fronts. However, the spacing is narrower for DE since the velocity of light is lower in the second medium.  One could perform the same construction for other rays in the diagram, generating a spherical wave when the wave front strikes the interface DB. The outgoing plane waves are tangent to the circular/spherical wave fronts generated at the interface, where one must take care to match up wave fronts that correspond to equal times of transit.

\\image{http://psurl.s3.amazonaws.com/images/jc/huygens_snell-5ae9.jpg}{}{}

The foregoing gives a qualitative explanation of refraction which includes the prediction that waves entering a denser medium are bent towards the normal. However, Huygen's went further to derive Snell's law.  Consider a train of plane waves orthogonal to the parallel lines $BD$ and $AG$.  The wave front strikes the interface $GD$ and propagates from it via emission of spherical waves from point sources.  Because outgoing wave fronts are surfaces corresponding to equal transit times, the time of transit for $CD$ is equal to that of $GE$.  That is, $CD= c_1T$ and $GE = c_2T$, where $c_1$ is the velocity of light in the upper medium and $c_2$ is the velocity in the lower medium.  Thus

\\begin{equation}
\\frac{GE}{CD} = \\frac{c_2}{c_1}
\\end{equation}

Next observer that the angle of incidence $\\theta_1$ is $\\angle AGB$ and that the angle of refraction $\\theta_2$ is $\\angle FGE$. One finds that $\\theta_1 = \\angle CGD$ and $\\theta_2 = \\angle GDE$.  Now $\\sin \\theta_1 = CD/GD$ and $\\sin\\theta_2 = GE/GD$.  Therefore

\\begin{equation}
\\frac{GE}{CD} = \\frac{\\sin\\theta_2}{\\sin\\theta_1}
\\end{equation}

Comparing the displayed equations, we find that

\\begin{equation}
\\frac{\\sin\\theta_2}{\\sin\\theta_1} = \\frac{c_2}{c_1}
\\end{equation}

Q.E.D.


\\subsection{Snell's Law via Quantum Mechanics}

Snell's Law was introduced in xref::59[[1]], where it was explained as a result of Fermat's principle of least time.  There is also a quantum-mechanical explanation based on the the principle of conservation of momentum for photons.
The starting point is the deBroglie relation, which relates particle momentum $p$ to wavelength $\\lambda$:

\\begin{equation}
p = h/\\lambda
\\end{equation}

Here $h$ is Planck's constant, $6.6\\times 10^{-34}$ Joule-sec.  For a wave propagating with speed $c$, one has $c = \\lambda\\nu$, where $\\nu$ is the frequency.  Thus one can rewrite the de Broglie relation as

\\begin{equation}
  p = \\frac{h\\nu}{c}
\\end{equation}


\\emph{The argument}

In  (<<debroglie2>>), $p$ stands for the magnitude of the momentum vector
$\\vec p$. Since momentum is a vector quantity, it is
conserved componentwise.  Therefore, if $\\vec p$ is the
momentum in the first medium and $\\vec p'$  is
the momentum in the second, we have $p_x = p'_x$ for the
$x$ component. By trigonometry, this reads $p\\sin\\theta_1 = p\\sin\\theta_2$  Using (<<debroglie2>>) and trigonometry, we
have

\\begin{equation}
\\frac{h\\nu}{c_1}\\;\\sin \\theta_1
=
\\frac{h \\nu}{c_2}\\;\\sin \\theta_2
\\end{equation}

Simplifying, we have Snell's law:

\\begin{equation}
\\frac{\\sin \\theta_1}{\\sin \\theta_2}
=
\\frac{c_1}{c_2}
\\end{equation}

.References
xref::59[[1]] *Snell's Law*.  Statement of Snell's law and derivation from Fermat's principle of least action.

"""
