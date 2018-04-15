package br.ufrj.ct.restauranteuniversitario;

import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.MenuItem;

import com.google.firebase.messaging.FirebaseMessaging;

import java.util.List;

/**
 * App main activity that holds all the fragments
 */
public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    private final String TAG = "MainActivity";
    private final String FRAGMENT_TAG_INITIAL = "Initial Fragment";
    private final String FRAGMENT_TAG_SCHEDULES = "Schedules Fragment";
    private final String FRAGMENT_TAG_GENERATOR = "Generator Fragment";
    private final String FRAGMENT_TAG_SEARCH = "Search Fragment";
    private final String FRAGMENT_TAG_OPTIONS = "Options Fragment";
    private final String FRAGMENT_TAG_SEARCH_RESULT = "Search Result Fragment";

    /**
     * The navigation view
     */
    NavigationView navigationView;

    /**
     * The item id from the menu
     */
    int itemId;

    /**
     * onCreate activity method.
     * This activity in general mostly deals with managing the fragments that are attached to it
     * @param savedInstanceState the savedInstanceState of this activity that might be used if
     *                           it restarts
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //set layout which is substituted by fragments layouts
        setContentView(R.layout.activity_main);

        //add toolbar on top of the screen
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        //create drawer for the menu
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        //create navigation view for the menu
        navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);

        //instantiates the fragment manager to deal with fragments transactions
        FragmentManager fm = getSupportFragmentManager();
        MenuFragment menuFragment = (MenuFragment) fm.findFragmentByTag(FRAGMENT_TAG_INITIAL);

        //Transaction to initial fragment if it hasn't been generated yet or to Disconnected fragment
        if(menuFragment == null) {
            menuFragment = new MenuFragment();
            FragmentTransaction ft = fm.beginTransaction();

            ft.add(R.id.main_frame, menuFragment, FRAGMENT_TAG_INITIAL);

            //check home button on menu
            navigationView.setCheckedItem(R.id.week_menu);

            ft.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE);
            ft.commit();

            //set toolbar title accordingly
            getSupportActionBar().setTitle(R.string.app_main_label);
        } else {
            //if initial fragment has been created already and the activity has been re-created
            //(device orientation changed for example select the current fragment instead
            if(savedInstanceState != null) {
                //get the last saved menu item id
                itemId = savedInstanceState.getInt("ItemId");
            }
        }
        //all devices are subscribed to topic "all" in order to receive push messages when necessary
        FirebaseMessaging.getInstance().subscribeToTopic("all");
    }

    /**
     * Method to deal when user hits the device back button. Menu and navigation drawer need attention.
     */
    @Override
    public void onBackPressed() {
        //initialize the drawer just in case
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        //if the drawer is opened, close it and don't do anything with fragments
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        }

        //if drawer is closed, go to previous fragment, change the menu item selected and toobar
        //title accordingly and refresh itemId variable
        else {
            super.onBackPressed();
            //get current fragment
            Fragment current = getVisibleFragment();
            //set the menu item checked and title variable according to the current fragment
            if (current instanceof MenuFragment) {
                navigationView.setCheckedItem(R.id.week_menu);
                itemId = R.id.week_menu;
            }
            else if (current instanceof QueuesFragment) {
                navigationView.setCheckedItem(R.id.available_queues);
                itemId = R.id.available_queues;
            } else if (current instanceof TicketSearcherFragment || current instanceof TicketSearchResultFragment) {
                navigationView.setCheckedItem(R.id.ticket_search);
                itemId = R.id.ticket_search;
            } else if (current instanceof TicketAllocatorFragment) {
                navigationView.setCheckedItem(R.id.ticket_allocator);
                itemId = R.id.ticket_allocator;
            } else if (current instanceof  OptionsFragment || current instanceof HoursFragment
                    || current instanceof RatingFragment || current instanceof NotificationsFragment) {
                navigationView.setCheckedItem(R.id.options);
                itemId = R.id.options;
            }
        }
    }

    /**
     * Method that is called when the user selects a menu item on navigation view
     * @param item selected menu item
     * @return Boolean true if no problem has happend and Boolean false otherwise
     */
    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        Fragment fragment = null;
        Fragment current = getVisibleFragment();
        itemId = item.getItemId();
        String fragmentTag = "";

        //get the current fragment and the selected fragment, if they are not the same, set the
        //fragment variable, the title variable and the fragmentTag variable according to selected
        //menu item
        if (itemId == R.id.week_menu && !(current instanceof MenuFragment)) {
            fragment = new MenuFragment();
            fragmentTag = FRAGMENT_TAG_INITIAL;
        }
        else if (itemId == R.id.available_queues && !(current instanceof QueuesFragment)) {
            fragment = new QueuesFragment();
            fragmentTag = FRAGMENT_TAG_SCHEDULES;
        } else if (itemId == R.id.ticket_search && !(current instanceof TicketSearcherFragment)) {
            fragment = new TicketSearcherFragment();
            fragmentTag = FRAGMENT_TAG_SEARCH;
        } else if (itemId == R.id.ticket_allocator && !(current instanceof TicketAllocatorFragment)) {
            fragment = new TicketAllocatorFragment();
            fragmentTag = FRAGMENT_TAG_GENERATOR;
        } else if (itemId == R.id.options && !(current instanceof OptionsFragment)) {
            fragment = new OptionsFragment();
            fragmentTag = FRAGMENT_TAG_OPTIONS;
        }

        //transact to selected fragment
        if (fragment != null) {
            FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
            ft.addToBackStack(fragmentTag);
            ft.replace(R.id.main_frame, fragment, fragmentTag);
            ft.commit();
        }

        //initialize and close drawer
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    /**
     * Method to get the current fragment
     * @return the current fragment on screen
     */
    public Fragment getVisibleFragment(){
        FragmentManager fragmentManager = MainActivity.this.getSupportFragmentManager();
        List<Fragment> fragments = fragmentManager.getFragments();
        if(fragments != null){
            for(Fragment fragment : fragments){
                if(fragment != null && fragment.isVisible())
                    return fragment;
            }
        }
        return null;
    }

    /**
     * save itemId variable on saved instance
     * @param state the current state of item to be saved
     */
    @Override
    public void onSaveInstanceState(Bundle state) {
        super.onSaveInstanceState(state);
        state.putInt("ItemId", itemId);
    }



}

